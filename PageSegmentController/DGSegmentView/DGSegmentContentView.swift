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
private let CellID = "DGSegmentCell"
class DGSegmentContentView: UIView {
    
    weak var delegate: DGSegmentContentViewDelegate?
    var isForbidScroll = false
    
    /// 初始化后，默认显示的页数
    public var currentIndex: Int = 0
    private var startOffsetX: CGFloat = 0
   
    //下方controller的scrollview
    private lazy var mainContentView: UICollectionView = {[unowned self] in
        let layout = DGSegmentViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        return collectionView
    }()
   
    //存储各栏目的controller
    var controllerArray: [UIViewController]?{
        didSet{
            mainContentView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainContentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainContentView.frame = self.bounds
        let layout = mainContentView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = bounds.size
        mainContentView.contentOffset = CGPoint(x: self.bounds.width * CGFloat(currentIndex), y: 0)
    }
}

extension DGSegmentContentView: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childViewController = controllerArray![indexPath.item]
        childViewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childViewController.view)
        
        return cell
    }
    
    
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
        if mainContentView.contentOffset.x > startOffsetX { // 左滑动
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
        let offsetX = CGFloat(currentIndex) * mainContentView.frame.width
        mainContentView.setContentOffset(CGPoint(x:offsetX, y:0), animated: false)
    }
}

class DGSegmentViewFlowLayout: UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if !newBounds.size.equalTo(collectionView!.bounds.size) {
            itemSize = newBounds.size
            return true
        }
        return false
    }
}
