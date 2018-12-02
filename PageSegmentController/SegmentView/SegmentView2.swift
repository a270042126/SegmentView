//
//  SegmentView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class SegmentView2: UIView {
    
    
    var config: SegmentConfiguration
    
    private lazy var titleView: SegmentTitleView = SegmentTitleView(frame: .zero, config: config, titleArray: titleArray)
    private lazy var contentView: SegmentContentView = SegmentContentView(frame: .zero, controllerArray: controllerArray)
    private var controllerArray: [UIViewController]
    private var titleArray: [String]
    
    init(frame: CGRect,configuration: SegmentConfiguration, titleArray: [String], controllerArray: [UIViewController]) {
        self.config = configuration
        self.titleArray = titleArray
        self.controllerArray = controllerArray
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sWidth = self.bounds.width
        let sHeight = self.bounds.height
        titleView.frame = CGRect(x: 0, y: 0, width: sWidth, height: config.titleHeight)
        contentView.frame = CGRect(x: 0, y: titleView.frame.maxY, width: sWidth, height: sHeight - config.titleHeight)
    }
    
}

extension SegmentView2{
    
    private func setUI(){
        self.backgroundColor = UIColor.white
        titleView.delegate = self
        contentView.delegate = self
        addSubview(titleView)
        addSubview(contentView)
    }
}

extension SegmentView2: SegmentTitleViewDelegate{
    func segmentTitleView(_ titleView: SegmentTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

extension SegmentView2: SegmentContentViewDelegate{
    func segmentContentView(_ contentView: SegmentContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
