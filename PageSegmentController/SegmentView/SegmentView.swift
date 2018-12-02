//
//  SegmentView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class SegmentView: UIView {
    
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
    lazy var channelView = UIView()
    private var config: SegmentConfiguration
    
    init(frame: CGRect,configuration: SegmentConfiguration) {
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
