//
//  SFMenuActionCell.swift
//  Saifanbox
//
//  Created by who on 2024/2/28.
//

import UIKit

class SFMenuActionCell: UITableViewCell {

    let actionIconImage = UIImageView()
    let actionNameLabel = UILabel()
    let lineLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(actionIconImage)
        actionIconImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(16)
            make.top.equalTo(self.contentView).offset(15)
            make.bottom.equalTo(self.contentView).offset(-15)
            make.size.equalTo(20)
        }
        
        self.contentView.addSubview(actionNameLabel)
        actionNameLabel.font = UIDevice.currentDeviceType() == "iPad" ? UIFont.systemFont(ofSize: 19) : UIFont.systemFont(ofSize: 16)
        actionNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(actionIconImage)
            make.left.equalTo(actionIconImage.snp.right).offset(8)
            make.right.equalTo(self.contentView).offset(-16)
        }
        
        self.contentView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView)
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
    
    required init? (coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
