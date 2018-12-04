//
//  SegmentConfiguration.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/2.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

enum DGSliderType: Int{
    case line = 0
    case cover = 1
}

class DGSegmentConfiguration {
    //标题
    public var titleHeight: CGFloat = 40
    public var titleWidth: CGFloat = 0
    //内边距
    public var padding:CGFloat = 15
    public var titleColor: UIColor = UIColor.black
    public var titleFontSize: CGFloat = 14
    public var selectedTitleColor: UIColor = UIColor.orange
    //标题绽放
    public var isTitleScaleEnabled = false
    public var titleMaximumScaleFactor: CGFloat = 1.2
    //滑块
    public var isSliderEnable = true
    public var sliderType = DGSliderType.line
    public var lineHeight: CGFloat = 2
    public var lineBackgroundColor: UIColor = UIColor.orange
    //遮盖
    public var coverHeight: CGFloat = 30
    public var coverBackgroundColor: UIColor = UIColor.red
    public var coverCornerRadius: CGFloat = 15
    //频道按钮
    public var isAddChannelEnabled = false
}
