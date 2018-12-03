//
//  PegeSementView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/1.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

protocol DGSegmentContentViewDelegate: class {
    func segmentContentView(_ contentView: DGSegmentContentView,  sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class DGSegmentContentView: UIView {
    
    weak var delegate: DGSegmentContentViewDelegate?
    var isForbidScroll = false
    
    /// 初始化后，默认显示的页数
    public var currentIndex: Int = 0
    
    private var startOffsetX: CGFloat = 0
   
    //下方controller的scrollview
    private lazy var mainScrollView: UIScrollView = {[unowned self] in
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.init(white: 0.900, alpha: 1.000)
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        return scrollView
    }()
   
    //存储各栏目的controller
    var controllerArray: [UIViewController]?{
        didSet{
            guard let controllerArray = controllerArray else {return}
            for vc in controllerArray {
                mainScrollView.addSubview(vc.view)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainScrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        mainScrollView.frame = self.bounds
        
        guard  controllerArray != nil && controllerArray!.count > 0 else {return}
        mainScrollView.contentSize =  CGSize(width: self.bounds.width * CGFloat(controllerArray!.count), height: self.bounds.height)
        mainScrollView.contentOffset = CGPoint(x: self.bounds.width * CGFloat(currentIndex), y: 0)
        
        for(index, _) in controllerArray!.enumerated(){
            let controller = controllerArray![index]
            controller.view.frame = CGRect(x: self.bounds.width * CGFloat(index), y: 0, width: self.bounds.width, height: self.bounds.height)
        }
    }
}

extension DGSegmentContentView: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScroll {return}
        guard let controllerArray = controllerArray else {return}
        
        var progress: CGFloat = 0
        var targetIndex = 0
        var sourceIndex = 0
        
        
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
        if progress == 0 {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if mainScrollView.contentOffset.x > startOffsetX { // 左滑动
            sourceIndex = index
            targetIndex = index + 1
            guard targetIndex < controllerArray.count else { return }
        } else {
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        }
        
        if progress > 0.998 {
            progress = 1
        }
        
        if progress > 0.5{
            currentIndex = targetIndex
        }else{
            currentIndex = sourceIndex
        }
        delegate?.segmentContentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}

extension DGSegmentContentView{
    func setCurrentIndex(_ currentIndex: Int){
        isForbidScroll = true
        self.currentIndex = currentIndex
        let offsetX = CGFloat(currentIndex) * mainScrollView.frame.width
        mainScrollView.setContentOffset(CGPoint(x:offsetX, y:0), animated: false)
    }
}

