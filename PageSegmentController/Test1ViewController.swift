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
        segementVC = SegmentView()
        segementVC.parentViewController = self
        segementVC.titleArray = ["社会","科技","娱乐","体育育","美女美女","动物动物动物","体育1","美女1","动物1"]
        for _ in segementVC.titleArray{
            let vC = UIViewController()
            vC.view.backgroundColor = UIColor.randomColor()
            segementVC.controllerArray.append(vC)
        }
        self.view.addSubview(segementVC)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segementVC.frame = self.view.bounds
    }



}
