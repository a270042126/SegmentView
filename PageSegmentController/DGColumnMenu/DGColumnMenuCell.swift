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
        return titleView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeButton)
        titleView.addSubview(addButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.frame = CGRect(x: contentView.frame.width - 25, y: -2, width: 18, height: 18)
        self.updateUI()
    }
}

extension DGColumnMenuCell{
    
    private func updateUI(){
        titleView.frame = CGRect(x: 5, y: 6.5, width: contentView.frame.width - 10, height: contentView.frame.height - 13)
        
        titleLabel.frame.size = getTextSize()
        
        if model!.isShowAdd{
            titleLabel.center = CGPoint(x: titleView.frame.width / 2 + 6, y: titleView.frame.height / 2)
        }else{
            titleLabel.center = CGPoint(x: titleView.frame.width / 2, y: titleView.frame.height / 2)
        }
        
        addButton.frame.size = CGSize(width: 10, height: 10)
        addButton.center.y = titleLabel.center.y
        addButton.center.x = titleLabel.frame.minX - 8
    }
    
    private func getTextSize() -> CGSize{
        let maxWidth = frame.width - 12
        return titleLabel.text!.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: titleLabel.font.pointSize)], context: nil).size
    }
}
