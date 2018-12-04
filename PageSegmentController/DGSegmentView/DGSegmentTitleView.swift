//
//  TopScrollView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
protocol DGSegmentTitleViewDelegate: class {
    func segmentTitleView(_ titleView: DGSegmentTitleView, selectedIndex index: Int)
}

class DGSegmentTitleView: UIView {
    
    weak var delegate: DGSegmentTitleViewDelegate?
    
    private var config: DGSegmentConfiguration!
    
    var titleArray: [String]?{
        didSet{
            guard let titleArray = titleArray else {return}
            //栏目按钮
            for(index, value) in titleArray.enumerated(){
                let titleButton = UIButton()
                titleButton.setTitle(value, for: .normal)
                titleButton.setTitleColor(config.titleColor, for: .normal)
                titleButton.setTitleColor(config.selectedTitleColor, for: .selected)
                titleButton.backgroundColor = UIColor.clear
                titleButton.tag = 100 + index
                titleButton.titleLabel?.font = UIFont.systemFont(ofSize: config.titleFontSize)
                titleButton.addTarget(self, action: #selector(scrollViewSelectToIndex), for:.touchUpInside)
                scrollView.addSubview(titleButton)
                if index == 0{
                    titleButton.isSelected = true
                    if config.isTitleScaleEnabled {
                        let scale = config.titleMaximumScaleFactor
                        titleButton.transform = CGAffineTransform(scaleX: scale, y: scale)
                    }
                }
                buttonArray.append(titleButton)
            }
            
            //滑块
            if config.isSliderEnable {
                var sliderViewWidth: CGFloat = 0
                if config.titleWidth == 0{
                    sliderViewWidth = getTextWidth(text: buttonArray.first!.titleLabel!.text!, height: config.titleHeight, fontSize:  buttonArray.first!.titleLabel!.font.pointSize)
                }else{
                    sliderViewWidth = config.titleWidth
                }
                
                switch config.sliderType {
                case .line:
                    sliderView.frame = CGRect(x: config.padding, y: config.titleHeight - config.lineHeight, width: sliderViewWidth, height: config.lineHeight)
                case .cover:
                    sliderView.frame = CGRect(x: 0, y: (config.titleHeight - config.coverHeight) / 2, width: sliderViewWidth, height: config.coverHeight)
                }
                scrollView.addSubview(sliderView)
                scrollView.sendSubviewToBack(sliderView)
            }
        }
    }
    
    private lazy var buttonArray = [UIButton]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    //滑块
    private lazy var sliderView: UIView = {
        let sliderView = UIView()
        switch config.sliderType {
        case .line:
            sliderView.backgroundColor = config.lineBackgroundColor
        case .cover:
            sliderView.backgroundColor = config.coverBackgroundColor
            sliderView.layer.masksToBounds = true
            sliderView.layer.cornerRadius = config.coverCornerRadius
        }
        return sliderView
    }()
    
    //选择的栏目
    private var currentIndex: Int = 0
    
    init(frame: CGRect, config:DGSegmentConfiguration) {
        self.config = config
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sHeight = self.bounds.height
        scrollView.frame = self.bounds
        
        guard buttonArray.count > 0 else {return}
        //按钮组
        var contentWidth: CGFloat = 0
        for(index, _) in buttonArray.enumerated(){
            let titleButton = buttonArray[index]
            var textWidth: CGFloat = 0
            if config.titleWidth == 0{
                textWidth = getTextWidth(text: titleButton.titleLabel!.text!, height: sHeight, fontSize: titleButton.titleLabel!.font.pointSize)
            }else{
                textWidth = config.titleWidth
            }
            titleButton.frame = CGRect(x: contentWidth, y: 0, width: (textWidth + config.padding * 2), height: sHeight)
            contentWidth += titleButton.frame.width
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: sHeight)
        selectedButton(index: currentIndex)
        
        if config.isSliderEnable{
            moveSilder(moveX: buttonArray[currentIndex].frame.minX, changeWidth: buttonArray[currentIndex].frame.width)
        }
    }
}

extension DGSegmentTitleView {
    
    private func setUI(){
        self.addSubview(scrollView)
    }
    
    private func selectedButton(index:Int){
        let sWidth = self.bounds.width
        var selectButton = buttonArray[currentIndex]
        selectButton.isSelected = false
        selectButton = buttonArray[index]
        currentIndex = index
        selectButton.isSelected = true
        
        let rect = selectButton.superview!.convert(selectButton.frame, to: self)
        let buttonWidth = selectButton.frame.width
        
        let contentWidth = buttonArray.last!.frame.maxX
        
        let contentOffset = scrollView.contentOffset;
        if contentOffset.x <= (sWidth / 2 - rect.origin.x - buttonWidth / 2){ //回到左边
            scrollView.setContentOffset(CGPoint(x: 0, y: contentOffset.y), animated: true)
        }else if contentOffset.x - (sWidth / 2 - rect.origin.x - buttonWidth / 2)  + sWidth >= contentWidth{ //回到右边
            scrollView.setContentOffset(CGPoint(x: contentWidth - sWidth, y: contentOffset.y), animated: true)
        }else{
            scrollView.setContentOffset(CGPoint(x:contentOffset.x - (sWidth / 2 - rect.origin.x - buttonWidth / 2),y:contentOffset.y), animated: true)
        }
    }
    
    
    /**
     内容宽度
     */
    private func getTextWidth(text: String, height: CGFloat, fontSize: CGFloat) -> CGFloat{
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.width
    }
    
    @objc private func scrollViewSelectToIndex(sender: UIButton){
        
        let index = sender.tag - 100
        selectedButton(index: index)
        
        if config.isSliderEnable {
            let selectButton = buttonArray[index]
            UIView.animate(withDuration: 0.25) {
                self.moveSilder(moveX: selectButton.frame.minX, changeWidth: selectButton.frame.width)
            }
        }
        delegate?.segmentTitleView(self, selectedIndex: index)
    }
    
    private func moveSilder(moveX: CGFloat, changeWidth: CGFloat){
        switch config.sliderType {
        case .line:
            sliderView.frame.origin.x =  moveX + config.padding
            sliderView.frame.size.width = changeWidth - config.padding * 2
        case .cover:
            sliderView.frame.origin.x =  moveX
            sliderView.frame.size.width = changeWidth
        }
        
    }
    
    private func setSelectedButtonScale(sourceIndex: Int, targetIndex: Int, progress: CGFloat){
        guard config.isTitleScaleEnabled else {return}
        let scale = config.titleMaximumScaleFactor - (config.titleMaximumScaleFactor - 1) * progress
        buttonArray[sourceIndex].transform = CGAffineTransform(scaleX: scale, y: scale)
        let scale2 = 1 + (config.titleMaximumScaleFactor - 1) * progress
        buttonArray[targetIndex].transform = CGAffineTransform(scaleX: scale2, y: scale2)
    }
}

extension DGSegmentTitleView{
    
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        let sourceButton = buttonArray[sourceIndex]
        let targetButton = buttonArray[targetIndex]
        let moveTotalX = targetButton.frame.origin.x - sourceButton.frame.origin.x
        let moveX = moveTotalX * progress
        let moveWidth = (targetButton.frame.width - sourceButton.frame.width) * progress

        if config.isSliderEnable{
            moveSilder(moveX: sourceButton.frame.origin.x + moveX, changeWidth: sourceButton.frame.width + moveWidth)
        }

        if progress > 0.5{
            self.selectedButton(index: Int(targetIndex))
        }else{
            self.selectedButton(index: Int(sourceIndex))
        }
        
        setSelectedButtonScale(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    func setSelectedButton(index: Int){
        selectedButton(index: index)
    }
}
