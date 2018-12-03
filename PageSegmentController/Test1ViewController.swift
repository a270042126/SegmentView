//
//  Test1ViewController.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/1.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class Test1ViewController: UIViewController {

    var segementVC: DGSegmentView!
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
        let config = DGSegmentConfiguration()
        config.isAddChannelEnabled = true
        segementVC = DGSegmentView(frame: .zero, configuration: config)
        segementVC.titleArray = titleArray
        segementVC.controllerArray = controllerArray
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("﹢", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        segementVC.channelView.addSubview(button)
        self.view.addSubview(segementVC)
    }
    
    @objc private func buttonClicked(){
        let tagsArray = ["要闻","视频","娱乐","军事","新时代","独家","广东","社会","图文","段子","搞笑视频"]
        let otherArrM = ["八卦","搞笑","短视频","图文段子","极限第一人"]
        let columnMenuVC = DGColumnMenuViewController(tagsArray: tagsArray, otherArray: otherArrM)
        columnMenuVC.delegate = self
        self.present(columnMenuVC, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segementVC.frame = self.view.bounds
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        segementVC.contentView.isForbidScroll = true
    }
   
}

extension Test1ViewController: DGColumnMenuViewDelegate{
    func columnMenuView(tagsArray: [String], otherArray: [String]) {
        print(tagsArray, otherArray)
    }
}
