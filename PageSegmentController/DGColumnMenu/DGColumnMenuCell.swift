//
//  DGColumnMenuCell.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/3.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DGColumnMenuCell: UICollectionViewCell {
    
    var model: DGColumnMenuModel? {
        didSet{
            switch model!.title.count {
            case 1, 2:
                titleLabel.font = UIFont.systemFont(ofSize: 15)
            case 3:
                titleLabel.font = UIFont.systemFont(ofSize: 14)
            case 4:
                titleLabel.font = UIFont.systemFont(ofSize: 13)
            default:
                titleLabel.font = UIFont.systemFont(ofSize: 12)
            }
      
            if !model!.isDelete {
                closeButton.isHidden = true
            }else{
                closeButton.isHidden = !model!.isShowClose
            }
            addButton.isHidden = !model!.isShowAdd
            titleLabel.text = model!.title
            self.updateUI()
        }
    }
    
    lazy var addButton: UIButton = {
        let addButton = UIButton()
        let bundle = Bundle(path: Bundle.main.path(forResource: "DGColumnMenu", ofType: "bundle")!)
        let imageName = bundle!.path(forResource: "add", ofType: "png")!
        addButton.setImage(UIImage(named: imageName), for: .normal)
        addButton.isHidden = true
        return addButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 5.0
        titleLabel.backgroundColor = UIColor.clear
        return titleLabel
    }()
    
    lazy var closeButton: UIButton = { [unowned self] in
        let closeButton = UIButton()
        let bundle = Bundle(path: Bundle.main.path(forResource: "DGColumnMenu", ofType: "bundle")!)
        let imageName = bundle!.path(forResource: "close", ofType: "png")!
        closeButton.setImage(UIImage(named: imageName), for: .normal)
        closeButton.isHidden = true
        return closeButton
    }()
    
    private lazy var titleView: UIView = {
        let titleView = UIView()
        titleView.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        titleView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 4
        return titleView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleView)
        contentView.addSubview(closeButton)
        titleView.addSubview(titleLabel)
        titleView.addSubview(addButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let closeButtonX = contentView.frame.width - 21
        let closeButtonY: CGFloat = 4
        let closeButtonWH: CGFloat = 18
        closeButton.frame = CGRect(x: closeButtonX, y: closeButtonY, width: closeButtonWH, height: closeButtonWH)
        self.updateUI()
    }
}

extension DGColumnMenuCell{
    
    private func updateUI(){
        
        let titleViewX: CGFloat = 5
        let titleViewY: CGFloat = 6.5
        let titleViewW = contentView.frame.width - 10
        let titleViewH = contentView.frame.height - 13
        titleView.frame = CGRect(x: titleViewX, y: titleViewY, width: titleViewW, height: titleViewH)
        
        var titleLabelCenterX: CGFloat
        if model!.isShowAdd{
            titleLabelCenterX = titleView.frame.width / 2 + 6
        }else{
            titleLabelCenterX = titleView.frame.width / 2
        }
        let  titleLabelCenterY = titleView.frame.height / 2
        titleLabel.center = CGPoint(x: titleLabelCenterX, y: titleLabelCenterY)
        titleLabel.frame.size = getTextSize()
        
        let addButtonCenterX = titleLabel.frame.minX - 6
        let addButtonCenterY = titleLabel.center.y
        let addButtonWH: CGFloat = 10
        addButton.center.y = addButtonCenterY
        addButton.center.x = addButtonCenterX
        addButton.frame.size = CGSize(width: addButtonWH, height: addButtonWH)
    }
    
    private func getTextSize() -> CGSize{
        let maxWidth = frame.width - 12
        return titleLabel.text!.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: titleLabel.font.pointSize)], context: nil).size
    }
}
