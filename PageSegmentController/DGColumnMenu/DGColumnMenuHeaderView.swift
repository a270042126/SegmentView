//
//  DGColumnMenuHeaderView.swift
//  PageSegmentController
//
//  Created by dd on 2018/12/3.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DGColumnMenuHeaderView: UICollectionReusableView {
    
    var editBtnClickedClosure: (()->())?
    
    lazy var editButton: UIButton = {[unowned self] in
        let editButton = UIButton()
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitle("完成", for: .selected)
        editButton.setTitleColor(UIColor.red, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton.layer.masksToBounds = true
        editButton.layer.cornerRadius = 6.0
        editButton.layer.borderColor = UIColor.red.cgColor
        editButton.layer.borderWidth = 1.0
        editButton.isHidden = true
        editButton.addTarget(self, action: #selector(editBtnClicked(sender:)), for: .touchUpInside)
        return editButton
    }()
    
    var title:String?{
        didSet{
            titleLabel.text = title
            updateUI()
        }
    }
    var detail:String?{
        didSet{
            detailLabel.text = detail
        }
    }
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        return detailLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(editButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
        let editButtonW: CGFloat = 50
        let editButtonH: CGFloat = 24
        let editButtonX = bounds.width - editButtonW - 8
        let editButtonY = (bounds.height - editButtonH) * 0.5
        editButton.frame = CGRect(x: editButtonX, y: editButtonY, width: editButtonW, height: editButtonH)
    }

    private func updateUI(){
        let titleLabelX: CGFloat = 12
        let titleLabelW = getTextSize().width
        let titleLabelH: CGFloat = 16
        let titleLabelY = frame.height / 2 - titleLabelH / 2
        titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        
        let detailLabelW: CGFloat = 140
        let detailLabelH: CGFloat = 16
        let detailLabelY: CGFloat = titleLabelY
        let detailLabelX = titleLabel.frame.maxX + 10
        detailLabel.frame = CGRect(x: detailLabelX, y: detailLabelY, width: detailLabelW, height: detailLabelH)
    }
}

extension DGColumnMenuHeaderView{
    
    @objc private func editBtnClicked(sender: UIButton){
        editBtnClickedClosure?()
    }
    
    private func getTextSize() -> CGSize{
        let maxWidth = frame.width - 12
        return titleLabel.text!.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: titleLabel.font.pointSize)], context: nil).size
    }
}
