//
//  HomeAddCategoryController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class HomeAddCategoryController: DGColumnMenuViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tagsArray = [ColumnMenuModel]()
        var otherArray = [ColumnMenuModel]()
        let tagsArrM = ["要闻","视频","娱乐","军事","新时代","独家","广东","社会","图文","段子","搞笑视频"]
        let otherArrM = ["八卦","搞笑","短视频","图文段子","极限第一人"]
        for value in tagsArrM {
            let model = ColumnMenuModel()
            model.title = value
            tagsArray.append(model)
        }
        
        for value in otherArrM{
            let model = ColumnMenuModel()
            model.title = value
            otherArray.append(model)
        }
        
        self.tagsArray = tagsArray
        self.otherArray = otherArray
        
        self.collectionView.reloadData()
    }
}

extension HomeAddCategoryController{
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! DGColumnMenuCell
        if indexPath.section == 0 {
            cell.title = (tagsArray[indexPath.item] as! ColumnMenuModel).title
        }else{
            cell.title = (otherArray[indexPath.item] as! ColumnMenuModel).title
        }
        return cell
    }
}
