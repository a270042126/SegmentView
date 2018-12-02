//
//  PegeSementView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/1.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

protocol SegmentContentViewDelegate: class {
    func segmentContentView(_ contentView: SegmentContentView,  sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class SegmentContentView: UIView {
    
    /// 初始化后，默认显示的页数
    public var currentIndex: Int = 0
    
    private var startOffsetX: CGFloat = 0
    private var isForbidScroll = false
    weak var delegate: SegmentContentViewDelegate?
   
    
    //下方controller的scrollview
    private lazy var mainCollectionView: UICollectionView = {[unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SegmentCollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "\(UICollectionViewCell.self)")
        return collectionView
    }()
   
    //存储各栏目的controller
    private var controllerArray: [UIViewController]

    init(frame: CGRect, controllerArray: [UIViewController]) {
        self.controllerArray = controllerArray
        super.init(frame: frame)
        self.addSubview(mainCollectionView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        mainCollectionView.frame = self.bounds
        let layout = mainCollectionView.collectionViewLayout as! SegmentCollectionViewFlowLayout
        layout.itemSize = self.bounds.size
        layout.offset = CGFloat(currentIndex) * bounds.size.width
    }

}


extension SegmentContentView: UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(UICollectionViewCell.self)", for: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVc = controllerArray[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

extension SegmentContentView: UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateUI(scrollView)
    }
    
    private func updateUI(_ scrollView: UIScrollView){
        if isForbidScroll {return}
        
        var progress: CGFloat = 0
        var targetIndex = 0
        var sourceIndex = 0
        
        
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
        if progress == 0 {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if mainCollectionView.contentOffset.x > startOffsetX { // 左滑动
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
        
        delegate?.segmentContentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)

    }
}

extension SegmentContentView{
    func setCurrentIndex(_ currentIndex: Int){
        isForbidScroll = true
        let offsetX = CGFloat(currentIndex) * mainCollectionView.frame.width
        mainCollectionView.setContentOffset(CGPoint(x:offsetX, y:0), animated: false)
    }
}

class SegmentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var offset: CGFloat?
    
    override open func prepare() {
        super.prepare()
        guard let offset = offset else { return }
        collectionView?.contentOffset = CGPoint(x: offset, y: 0)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    }
}
