//
//  TopScrollView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
protocol SegmentTitleViewDelegate: class {
    func segmentTitleView(_ titleView: SegmentTitleView, selectedIndex index: Int)
}

class SegmentTitleView: UIView {
    
    var delegate: SegmentTitleViewDelegate?
    
    private var config: SegmentConfiguration
    private lazy var buttonArray = [UIButton]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    //滑块
    private lazy var sliderView: UIView = {
        let sliderView = UIView()
        sliderView.backgroundColor = UIColor.orange
        sliderView.isHidden = !config.isShowSlider
        return sliderView
    }()
    
    private var titleArray: [String]
    //选择的栏目
    private var selectButton: UIButton?
    
    init(frame: CGRect, config:SegmentConfiguration, titleArray: [String]) {
        self.config = config
        self.titleArray = titleArray
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
    }
    
}

extension SegmentTitleView {
    
    private func setUI(){
        self.addSubview(scrollView)
        //栏目按钮
        for(index, value) in titleArray.enumerated(){
            let titleButton = UIButton()
            titleButton.setTitle(value, for: .normal)
            titleButton.setTitleColor(UIColor.black, for: .normal)
            titleButton.tag = 100 + index
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            titleButton.addTarget(self, action: #selector(scrollViewSelectToIndex), for:.touchUpInside)
            scrollView.addSubview(titleButton)
            if index == 0{
                selectButton = titleButton
                selectButton?.setTitleColor(UIColor.orange, for: .normal)
            }
            buttonArray.append(titleButton)
        }
        var sliderViewWidth: CGFloat = 0
        if config.titleWidth == 0{
            sliderViewWidth = getTextWidth(text: selectButton!.titleLabel!.text!, height: config.titleHeight, fontSize: selectButton!.titleLabel!.font.pointSize)
        }else{
            sliderViewWidth = config.titleWidth
        }
        
        sliderView.frame = CGRect(x: config.padding, y: config.titleHeight - config.sliderHeight, width: sliderViewWidth, height: config.sliderHeight)

        scrollView.addSubview(sliderView)
    }
    
    private func selectedButton(index:Int){
        let sWidth = self.bounds.width
        selectButton?.setTitleColor(UIColor.black, for: .normal)
        selectButton = buttonArray[index]
        selectButton?.setTitleColor(UIColor.orange, for: .normal)
        
        let rect = selectButton!.superview!.convert(selectButton!.frame, to: self)
        let buttonWidth = selectButton!.frame.width
        
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
        
        UIView.animate(withDuration: 0.25) {
            self.sliderView.frame.origin.x = self.selectButton!.frame.minX + self.config.padding
            self.sliderView.frame.size.width = self.selectButton!.frame.width - self.config.padding * 2
        }
        
        delegate?.segmentTitleView(self, selectedIndex: index)
    }
    
}

extension SegmentTitleView{
    
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        let sourceButton = buttonArray[sourceIndex]
        let targetButton = buttonArray[targetIndex]
        let moveTotalX = targetButton.frame.origin.x - sourceButton.frame.origin.x
        let moveX = moveTotalX * progress
        let moveWidth = (targetButton.frame.width - sourceButton.frame.width) * progress

        self.sliderView.frame.origin.x = sourceButton.frame.origin.x + moveX + config.padding
        self.sliderView.frame.size.width = sourceButton.frame.width + moveWidth - config.padding * 2

        self.selectedButton(index: Int(targetIndex))
    }
}
