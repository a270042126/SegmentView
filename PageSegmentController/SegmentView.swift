//
//  PegeSementView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/1.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class SegmentView: UIView {
    
    //var titleWidth: CGFloat = 80
    var titleHeight: CGFloat = 40
    var sliderHeight: CGFloat = 2
    var padding:CGFloat = 15
    var isShowSlider = true
    weak var parentViewController: UIViewController?
    
    //存储栏目标题
    var titleArray = [String](){
        didSet{
            //栏目按钮
            for(index, value) in titleArray.enumerated(){
                let titleButton = UIButton()
                titleButton.setTitle(value, for: .normal)
                titleButton.setTitleColor(UIColor.black, for: .normal)
                titleButton.tag = 100 + index
                titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                titleButton.addTarget(self, action: #selector(scrollViewSelectToIndex), for:.touchUpInside)
                topScrollView.addSubview(titleButton)
                if index == 0{
                    selectButton = titleButton
                    selectButton?.setTitleColor(UIColor.orange, for: .normal)
                }
                buttonArray.append(titleButton)
            }
            
            let sliderViewWidth = getTextWidth(text: selectButton!.titleLabel!.text!, height: titleHeight, fontSize: selectButton!.titleLabel!.font.pointSize)
            sliderView.frame = CGRect(x: padding, y: titleHeight - sliderHeight, width: sliderViewWidth, height: sliderHeight)
            topScrollView.addSubview(sliderView)
        }
    }
    //存储各栏目的controller
    var controllerArray = [UIViewController](){
        didSet{
            for viewController in controllerArray{
                var view = UIView()
                view = viewController.view
                parentViewController?.addChild(viewController)
                mainScrollView.addSubview(view)
            }
        }
    }
    
    
    
    private var startOffsetX: CGFloat = 0
    private var isForbidScroll = false
    //选择的栏目
    private var selectButton: UIButton?
     //标题组
    private lazy var buttonArray = [UIButton]()
    //滑块
    private lazy var sliderView: UIView = {
        let sliderView = UIView()
        sliderView.backgroundColor = UIColor.orange
        sliderView.isHidden = !isShowSlider
        return sliderView
    }()
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
    //上方的scrollview
    private lazy var topScrollView:UIScrollView = {
        //滑动ScrollView
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        //让滚动条闪动一次
        scrollView.flashScrollIndicators()
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sWidth = self.bounds.width
        let sHeight = self.bounds.height
        //上方的scrollview
        topScrollView.frame = CGRect(x: 0, y: 0, width: sWidth, height: titleHeight)
        
        //按钮组
        var contentWidth: CGFloat = 0
        for(index, _) in buttonArray.enumerated(){
            let titleButton = buttonArray[index]
            let textWidth = getTextWidth(text: titleButton.titleLabel!.text!, height: titleHeight, fontSize: titleButton.titleLabel!.font.pointSize)
            titleButton.frame = CGRect(x: contentWidth, y: 0, width: (textWidth + padding * 2), height: self.titleHeight)
            contentWidth += titleButton.frame.width
        }
        
        topScrollView.contentSize = CGSize(width: contentWidth, height: titleHeight)
        
        mainScrollView.frame = CGRect(x: 0, y: topScrollView.frame.maxY, width: sWidth, height: sHeight - titleHeight)
        mainScrollView.contentSize =  CGSize(width: sWidth * CGFloat(controllerArray.count), height: sHeight - titleHeight)
        
        let index = selectButton!.tag - 100
        mainScrollView.contentOffset = CGPoint(x: sWidth * CGFloat(index), y: 0)
        selectedButton(index: index)
        sliderView.frame.origin.x = buttonArray[index].frame.minX + padding
        sliderView.frame.size.width = buttonArray[index].frame.width  - self.padding * 2
        
        for(index, _) in controllerArray.enumerated(){
            let controller = controllerArray[index]
            controller.view.frame = CGRect(x: sWidth * CGFloat(index), y: 0, width: sWidth, height: sHeight)
        }
    }

}

extension SegmentView{
    
    private func setupUI(){
        self.addSubview(topScrollView)
        self.addSubview(mainScrollView)
    }
    
    @objc private func scrollViewSelectToIndex(sender: UIButton){
        isForbidScroll = true
        let sWidth = self.bounds.width
        selectedButton(index: sender.tag - 100)
        mainScrollView.contentOffset = CGPoint(x: sWidth * CGFloat(sender.tag - 100), y: 0)
        
        UIView.animate(withDuration: 0.25) {
            self.sliderView.frame.origin.x = self.selectButton!.frame.minX + self.padding
            self.sliderView.frame.size.width = self.selectButton!.frame.width - self.padding * 2
        }
    }
    
    private func selectedButton(index:Int){
        let sWidth = self.bounds.width
        selectButton?.setTitleColor(UIColor.black, for: .normal)
        selectButton = buttonArray[index]
        selectButton?.setTitleColor(UIColor.orange, for: .normal)
        
        let rect = selectButton!.superview!.convert(selectButton!.frame, to: self)
        let buttonWidth = selectButton!.frame.width
        
        let contentWidth = buttonArray.last!.frame.maxX
        
        let contentOffset = topScrollView.contentOffset;
        if contentOffset.x <= (sWidth / 2 - rect.origin.x - buttonWidth / 2){ //回到左边
            topScrollView.setContentOffset(CGPoint(x: 0, y: contentOffset.y), animated: true)
        }else if contentOffset.x - (sWidth / 2 - rect.origin.x - buttonWidth / 2)  + sWidth >= contentWidth{ //回到右边
            topScrollView.setContentOffset(CGPoint(x: contentWidth - sWidth, y: contentOffset.y), animated: true)
        }else{
            self.topScrollView.setContentOffset(CGPoint(x:contentOffset.x - (sWidth / 2 - rect.origin.x - buttonWidth / 2),y:contentOffset.y), animated: true)
        }
    }
 
    
    /**
     内容宽度
     */
    private func getTextWidth(text: String, height: CGFloat, fontSize: CGFloat) -> CGFloat{
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.width
    }
    
    
}

extension SegmentView: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if isForbidScroll {
            return
        }
        
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
        
        let sourceButton = buttonArray[sourceIndex]
        let targetButton = buttonArray[targetIndex]
        let moveTotalX = targetButton.frame.origin.x - sourceButton.frame.origin.x
        let moveX = moveTotalX * progress
        let moveWidth = (targetButton.frame.width - sourceButton.frame.width) * progress
        
        self.sliderView.frame.origin.x = sourceButton.frame.origin.x + moveX + self.padding
        self.sliderView.frame.size.width = sourceButton.frame.width + moveWidth - self.padding * 2
        
        self.selectedButton(index: Int(targetIndex))
    }
}



