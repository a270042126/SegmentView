//
//  Test1ViewController.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/1.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class Test1ViewController: UIViewController {

    var segementVC: SegmentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        let titleArray = ["社会","科技","娱乐","体育育","美女美女","动物动物动物","体育1","美女1","动物1","动物动物动物","体育1","美女1","动物1","动物动物动物","体育1","美女1","动物1"]
        
        var controllerArray = [UIViewController]()
        for _ in titleArray{
            let vC = UIViewController()
            vC.view.backgroundColor = UIColor.randomColor()
            self.addChild(vC)
            controllerArray.append(vC)
        }
        let config = SegmentConfiguration()
        segementVC = SegmentView(frame: .zero, configuration: config, titleArray: titleArray, controllerArray: controllerArray)
       
        
        self.view.addSubview(segementVC)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segementVC.frame = self.view.bounds
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        segementVC.contentView.isForbidScroll = true
    }
   
}
