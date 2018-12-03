//
//  DGColumnMenu.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/3.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

protocol DGColumnMenuViewDelegate:class {
    func columnMenuView(tagsArray: [String], otherArray: [String])
}

class DGColumnMenuViewController: UIViewController {
    
    weak var delegate: DGColumnMenuViewDelegate?
    
    private lazy var tagsArray:[DGColumnMenuModel] = [DGColumnMenuModel]()
    private lazy var otherArray:[DGColumnMenuModel] = [DGColumnMenuModel]()
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
    
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 4, right: 10);
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(DGColumnMenuCell.self, forCellWithReuseIdentifier: "\(DGColumnMenuCell.self)")
        collectionView.register(DGColumnMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(DGColumnMenuHeaderView.self)")
        collectionView.addGestureRecognizer(longPress)
        return collectionView
    }()
    
    private lazy var longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPress:)))
    
    init(tagsArray:[String], otherArray:[String]) {
        super.init(nibName: nil, bundle: nil)
        for (index, value) in tagsArray.enumerated(){
            let model = DGColumnMenuModel()
            model.title = value
            model.isShowAdd = false
            model.isShowClose = false
            if index == 0 {
                model.isDelete = false
            }
            self.tagsArray.append(model)
        }
        
        for value in otherArray{
            let model = DGColumnMenuModel()
            model.title = value
            model.isShowClose = false
            self.otherArray.append(model)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(navView)
        navView.addSubview(navTitle)
        navView.addSubview(navCloseButton)
        self.view.addSubview(collectionView)
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sWidth = self.view.bounds.width
        
        navView.frame = CGRect(x: 0, y: 0, width: sWidth, height: 64)
        navTitle.frame = CGRect(x: navView.center.x - 100, y: navView.center.y, width: 200, height: 20)
        navCloseButton.frame = CGRect(x: navView.frame.width - 30, y: navTitle.frame.minY, width: 20, height: 20)
    
        collectionView.frame = CGRect(x: 0, y: navView.frame.maxY, width: view.frame.width, height: view.frame.height - navView.frame.height)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: collectionView.frame.width * 0.25 - 10, height: 53)
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
            cell.model = tagsArray[indexPath.item]
            if indexPath.item == 0{
                cell.titleLabel.textColor = UIColor.red
            }
        }else{
            cell.model = otherArray[indexPath.item]
        }
        cell.closeButton.tag = indexPath.item
        cell.closeButton.addTarget(self, action: #selector(cellButtonClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(DGColumnMenuHeaderView.self )", for: indexPath) as! DGColumnMenuHeaderView
        
        if indexPath.section == 0 {
            headerView.editButton.isHidden = false
            headerView.titleLabel.text = "已选择频道"
            headerView.detailLabel.text = "按住拖动调整排序"
            headerView.editButton.isSelected = isEdit
            headerView.editBtnClickedClosure = { [unowned self] in
                self.headViewButtonnClicked()
            }
            
        } else{
            headerView.editButton.isHidden = true
            headerView.titleLabel.text = "选择频道"
            headerView.detailLabel.text = "点击添加频道"
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
        var model: DGColumnMenuModel
        if sourceIndexPath.section == 0{
            model = tagsArray[sourceIndexPath.item]
            tagsArray.remove(at: sourceIndexPath.item)
        } else {
            model = otherArray[sourceIndexPath.item]
            otherArray.remove(at: sourceIndexPath.item)
        }
        
        
        if destinationIndexPath.section == 0 {
            model.isShowClose = isEdit
            model.isShowAdd = false
            tagsArray.insert(model, at: destinationIndexPath.item)
        } else if destinationIndexPath.section == 1{
            model.isShowClose = false
            model.isShowAdd = true
            otherArray.insert(model, at: destinationIndexPath.item)
        }
        
        collectionView.reloadItems(at: [destinationIndexPath])
        updateArray()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.section == 1{
            let model = otherArray[indexPath.item]
            model.isShowAdd = false
            model.isShowClose = isEdit
            
            collectionView.reloadItems(at: [indexPath])
            otherArray.remove(at: indexPath.item)
            tagsArray.append(model)
            
            let targetIndexPath = IndexPath(item: tagsArray.count - 1, section: 0)
            collectionView.moveItem(at: indexPath, to: targetIndexPath)
            updateCloseButtonTag()
            updateArray()
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
            if indexPath != nil && (indexPath!.item == 0 || indexPath!.section == 1){
                return
            }
//            if !isEdit && indexPath!.section == 0{
//                headViewButtonnClicked()
//            }
            
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
        
        model.isShowClose = false
        model.isShowAdd = true
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.reloadItems(at: [indexPath])
        
        tagsArray.remove(at: index)
        otherArray.insert(model, at: 0)
        
        let targetIndexPath = IndexPath(item: 0, section: 1)
        collectionView.moveItem(at: indexPath, to: targetIndexPath)
        updateCloseButtonTag()
        updateArray()
    }
    
    private func headViewButtonnClicked(){
        isEdit = !isEdit
        if(isEdit){
            for item in tagsArray{
                item.isShowClose = true
            }
        }else{
            for item in tagsArray{
                item.isShowClose = false
            }
        }
        collectionView.reloadData()
    }
    
    
    private func updateCloseButtonTag(){
        for cell in collectionView.visibleCells{
            let tempCell = cell as! DGColumnMenuCell
            let indexPath = collectionView.indexPath(for: cell)
            tempCell.closeButton.tag = indexPath!.item
        }
    }
    
    private func updateArray(){
        let tempTagsArray = tagsArray.compactMap({$0.title})
        let tempOtherArray = otherArray.compactMap({$0.title})
        print(tempTagsArray,tempOtherArray)
        delegate?.columnMenuView(tagsArray: tempTagsArray, otherArray: tempOtherArray)
    }
}
