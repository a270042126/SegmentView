//
//  DGColumnMenu.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/3.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DGColumnMenuViewController: UIViewController {
    
    lazy var tagsArray:[Any] = [Any]()
    lazy var otherArray:[Any] = [Any]()
    
    private var isEdit = false

    private lazy var navView: UIView = {
        let navView = UIView()
        navView.backgroundColor = UIColor.black
        return navView
    }()
    
    
    private lazy var navTitle: UILabel = {
       let navTitle = UILabel()
        navTitle.text = "频道定制"
        navTitle.textAlignment = .center
        navTitle.textColor = UIColor.white
        return navTitle
    }()
    
    private lazy var navCloseButton: UIButton = {[unowned self] in
        let navCloseButton = UIButton()
        navCloseButton.setTitle("×", for: .normal)
        navCloseButton.setTitleColor(UIColor.white, for: .normal)
        navCloseButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        navCloseButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        return navCloseButton
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 4, right: 10);
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        collectionView.register(DGColumnMenuCell.self, forCellWithReuseIdentifier: "\(DGColumnMenuCell.self)")
        collectionView.register(DGColumnMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(DGColumnMenuHeaderView.self)")
        collectionView.addGestureRecognizer(longPress)
        return collectionView
    }()
    
    private lazy var longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPress:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(navView)
        navView.addSubview(navTitle)
        navView.addSubview(navCloseButton)
        self.view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navViewX: CGFloat = 0
        let navViewY: CGFloat = 0
        let navViewW = view.frame.width
        let navViewH: CGFloat = 64
        navView.frame = CGRect(x: navViewX, y: navViewY, width: navViewW, height: navViewH)
        
        let navTitleX = navView.center.x - 100
        let navTitleY = navView.center.y
        let navTitleW: CGFloat = 200
        let navTitleH: CGFloat = 20
        navTitle.frame = CGRect(x: navTitleX, y: navTitleY, width: navTitleW, height: navTitleH)
        
        let navCloseButtonX = navView.frame.width - 30
        let navCloseButtonY = navTitle.frame.minY
        let navCloseButtonWH: CGFloat = 20
        navCloseButton.frame = CGRect(x: navCloseButtonX, y: navCloseButtonY, width: navCloseButtonWH, height: navCloseButtonWH)
        
        var sWidth: CGFloat = 0
        if view.frame.width >= 600{
            sWidth = view.frame.width * 3 / 4
        }else{
            sWidth = view.frame.width
        }
        
        let collectionViewX: CGFloat = (view.frame.width - sWidth) * 0.5
        let collectionViewY = navView.frame.maxY
        let collectionViewW = sWidth
        let collectionViewH = view.frame.height - navView.frame.maxY
        collectionView.frame = CGRect(x: collectionViewX, y: collectionViewY, width: collectionViewW, height: collectionViewH)
        
        var magin: CGFloat = 10
        if view.bounds.width < 375{
            magin = 6
        }
        let itemWidth = collectionView.frame.width * 0.25 - magin
        let itemHeight: CGFloat = 53
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
}

extension DGColumnMenuViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return tagsArray.count
        }else{
            return otherArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DGColumnMenuCell.self)", for: indexPath) as! DGColumnMenuCell
        
        if indexPath.section == 0{
            //cell.title = tagsArray[indexPath.item].title
            cell.isShowAddButton = false
            cell.isShowClose = isEdit
            if indexPath.item == 0{
                cell.isDelete = false
            }
        }else{
            //cell.title = otherArray[indexPath.item].title
            cell.isShowAddButton = true
            cell.isShowClose = false
            cell.isDelete = true
        }
        cell.closeButton.tag = indexPath.item
        cell.closeButton.addTarget(self, action: #selector(cellButtonClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(DGColumnMenuHeaderView.self )", for: indexPath) as! DGColumnMenuHeaderView
        
        if indexPath.section == 0 {
            headerView.title = "已选择频道"
            headerView.detail = "按住拖动调整排序"
            headerView.editButton.isHidden = false
            headerView.editButton.isSelected = isEdit
            headerView.editBtnClickedClosure = { [unowned self] in
                self.headViewButtonnClicked()
            }
            
        } else{
            headerView.editButton.isHidden = true
            headerView.title = "选择频道"
            headerView.detail = "点击添加频道"
        }
        return headerView
    }
    
    //头部视图的大小
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var model: Any
        if sourceIndexPath.section == 0{
            model = tagsArray[sourceIndexPath.item]
            tagsArray.remove(at: sourceIndexPath.item)
        } else {
            model = otherArray[sourceIndexPath.item]
            otherArray.remove(at: sourceIndexPath.item)
        }
        
        
        if destinationIndexPath.section == 0 {
            tagsArray.insert(model, at: destinationIndexPath.item)
        } else if destinationIndexPath.section == 1{
            otherArray.insert(model, at: destinationIndexPath.item)
        }
        
        collectionView.reloadItems(at: [destinationIndexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.section == 1{
            let model = otherArray[indexPath.item]
            otherArray.remove(at: indexPath.item)
            tagsArray.append(model)
            
            let targetIndexPath = IndexPath(item: tagsArray.count - 1, section: 0)
            collectionView.moveItem(at: indexPath, to: targetIndexPath)
            collectionView.reloadItems(at: [targetIndexPath])
            updateCloseButtonTag()
        }
    }
}


extension DGColumnMenuViewController{
    
    @objc private func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func longPress(longPress: UIGestureRecognizer){
        let point = longPress.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        if longPress.state == UIGestureRecognizer.State.began{//长按手势状态开始
            if indexPath == nil {return}
            if(indexPath!.item == 0 || indexPath!.section == 1){
                return
            }
            collectionView.beginInteractiveMovementForItem(at: indexPath!)
        }else if longPress.state == UIGestureRecognizer.State.changed{//长按手势状态改变
            if indexPath != nil && indexPath!.item == 0{
                return
            }
            collectionView.updateInteractiveMovementTargetPosition(point)
        }else if longPress.state == UIGestureRecognizer.State.ended{  //长按手势结束
            collectionView.endInteractiveMovement()
        }else{//其他情况
            collectionView.cancelInteractiveMovement()
        }
    }
    
    @objc private func cellButtonClicked(sender: UIButton){
        let index = sender.tag
        let model = tagsArray[index]
        let indexPath = IndexPath(item: index, section: 0)
        tagsArray.remove(at: index)
        otherArray.insert(model, at: 0)
        
        let targetIndexPath = IndexPath(item: 0, section: 1)
        collectionView.moveItem(at: indexPath, to: targetIndexPath)
        collectionView.reloadItems(at: [targetIndexPath])
        updateCloseButtonTag()
    }
    
    private func headViewButtonnClicked(){
        isEdit = !isEdit
        collectionView.reloadData()
    }
    
    
    private func updateCloseButtonTag(){
        for cell in collectionView.visibleCells{
            let tempCell = cell as! DGColumnMenuCell
            let indexPath = collectionView.indexPath(for: cell)
            tempCell.closeButton.tag = indexPath!.item
        }
    }
}
