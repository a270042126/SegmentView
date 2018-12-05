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
        
        let titleArray = ["社会","科技","娱乐","体育育","体育体育1","体育体育2","体育体育2","体育体育3"]
        
        var controllerArray = [UIViewController]()
        for (index, _) in titleArray.enumerated(){
            let vC = Test2ViewController()
            if index == 0{
                vC.view.backgroundColor = UIColor.orange
            }else{
                vC.view.backgroundColor = UIColor.randomColor()
            }
            
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
        
       

        let columnMenuVC = HomeAddCategoryController()
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

//extension Test1ViewController: DGColumnMenuViewDelegate{
//    func columnMenuView(tagsArray: [AnyObject], otherArray: [AnyObject]) {
//        print(tagsArray, otherArray)
//    }
//}
