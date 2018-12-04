//
//  SegmentView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DGSegmentView: UIView {
    
    var controllerArray: [UIViewController] = [UIViewController](){
        didSet{
            contentView.controllerArray = controllerArray
        }
    }
    var titleArray: [String] = [String](){
        didSet{
            titleView.titleArray = titleArray
        }
    }
    
    lazy var titleView: DGSegmentTitleView = DGSegmentTitleView(frame: .zero, config: config)
    lazy var contentView: DGSegmentContentView = DGSegmentContentView(frame: .zero)
    lazy var channelView = UIView()
    private var config: DGSegmentConfiguration
    
    init(frame: CGRect,configuration: DGSegmentConfiguration = DGSegmentConfiguration()) {
        self.config = configuration
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        titleView.delegate = self
        contentView.delegate = self
        addSubview(titleView)
        addSubview(contentView)
        
        if config.isAddChannelEnabled {
            addSubview(channelView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sWidth = self.bounds.width
        let sHeight = self.bounds.height
        
        if config.isAddChannelEnabled{
             titleView.frame = CGRect(x: 0, y: 0, width: sWidth - config.titleHeight, height: config.titleHeight)
             channelView.frame = CGRect(x: titleView.frame.maxX, y: 0, width: config.titleHeight, height: config.titleHeight)
        }else{
             titleView.frame = CGRect(x: 0, y: 0, width: sWidth, height: config.titleHeight)
        }
        
        contentView.frame = CGRect(x: 0, y: titleView.frame.maxY, width: sWidth, height: sHeight - config.titleHeight)
    }
}


extension DGSegmentView: DGSegmentTitleViewDelegate{
    func segmentTitleView(_ titleView: DGSegmentTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

extension DGSegmentView: DGSegmentContentViewDelegate{
    func segmentContentView(_ contentView: DGSegmentContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
