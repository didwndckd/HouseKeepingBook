//
//  CustomCell.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
  let iconView = UILabel()
  let titlelabel = UILabel()
  let priceLabel = UILabel()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(iconView)
    contentView.addSubview(titlelabel)
    contentView.addSubview(priceLabel)
    iconView.backgroundColor = MyColors.lightgray
    iconView.layer.cornerRadius = iconView.frame.width/2
    iconView.layer.masksToBounds = true
    iconView.textAlignment = .center
    titlelabel.text = "지출 분류"
    titlelabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
    priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    priceLabel.text = "금-----액"
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    
  override func layoutSubviews() {
    super.layoutSubviews()
    let uiArr = [iconView, titlelabel, priceLabel]
    for ui in uiArr {
      ui.translatesAutoresizingMaskIntoConstraints = false
      ui.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    iconView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -8).isActive = true
    iconView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -8).isActive = true
    titlelabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10).isActive = true
    priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    
    iconView.layer.cornerRadius = (frame.height / 2) - 4
    
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
