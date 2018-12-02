//
//  SegmentView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

protocol SegmentViewDelegate:class {
    func segmentViewChannelButtonClicked()
}

class SegmentView: UIView {
    
    weak var delegate: SegmentViewDelegate?
    var controllerArray: [UIViewController]?{
        didSet{
            contentView.controllerArray = controllerArray
        }
    }
    var titleArray: [String]?{
        didSet{
            titleView.titleArray = titleArray
        }
    }
    
    lazy var titleView: SegmentTitleView = SegmentTitleView(frame: .zero, config: config)
    lazy var contentView: SegmentContentView = SegmentContentView(frame: .zero)
    
    private lazy var channelButton:UIButton = {
        let channelButton = UIButton()
        if config.channelButtonImage != ""{
            channelButton.setImage(UIImage(named: config.channelButtonImage), for: .normal)
        }else{
            channelButton.backgroundColor = UIColor.clear
            channelButton.setTitle(config.channelButtonText, for: .normal)
            channelButton.titleLabel?.font = UIFont.systemFont(ofSize: config.channelBUttonFontSize)
            channelButton.setTitleColor(config.channelButtonTextColor, for: .normal)
        }
        channelButton.addTarget(self, action: #selector(channelButtonClick), for: .touchUpInside)
        return channelButton
    }()
    
    private var config: SegmentConfiguration
    
    init(frame: CGRect,configuration: SegmentConfiguration) {
        self.config = configuration
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        titleView.delegate = self
        contentView.delegate = self
        addSubview(titleView)
        addSubview(contentView)
        if config.isShowChannelButton {
            addSubview(channelButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sWidth = self.bounds.width
        let sHeight = self.bounds.height
        
        if config.isShowChannelButton{
             titleView.frame = CGRect(x: 0, y: 0, width: sWidth - config.titleHeight, height: config.titleHeight)
             channelButton.frame = CGRect(x: titleView.frame.maxX, y: 0, width: config.titleHeight, height: config.titleHeight)
        }else{
             titleView.frame = CGRect(x: 0, y: 0, width: sWidth, height: config.titleHeight)
        }
        
        contentView.frame = CGRect(x: 0, y: titleView.frame.maxY, width: sWidth, height: sHeight - config.titleHeight)
    }
}

extension SegmentView{
    @objc private func channelButtonClick(){
        delegate?.segmentViewChannelButtonClicked()
    }
}

extension SegmentView: SegmentTitleViewDelegate{
    func segmentTitleView(_ titleView: SegmentTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

extension SegmentView: SegmentContentViewDelegate{
    func segmentContentView(_ contentView: SegmentContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
