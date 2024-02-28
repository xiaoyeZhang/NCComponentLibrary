//
//  SFMainMenuCollectionViewCell.swift
//  Saifanbox
//
//  Created by who on 2024/2/28.
//

import UIKit

class SFMainMenuCollectionViewCell: UICollectionViewCell {
 
    let iconImage = UIImageView()
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
    
        iconImage.image = UIImage(named: "commonUser")
        iconImage.layer.cornerRadius = 12
        iconImage.layer.masksToBounds = true
        self.contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(-8)
            make.size.equalTo(58)
        }
        
        nameLabel.font = UIDevice.currentDeviceType() == "iPad" ? UIFont.systemFont(ofSize: 14) : UIFont.systemFont(ofSize: 11)
        nameLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.13, alpha: 1.0)
        nameLabel.textAlignment = .center
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(8)
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
}
