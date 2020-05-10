//
//  StatsCell.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/19.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell {
    
    let tagView = UIView()
    let tagLabel = UILabel()
    let barView = UIView()
    let guageView = UIView()
    let percentLabel = UILabel()
    let priceLabel = UILabel()
    var percent: CGFloat = 0
    var guageWidth = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let margin: CGFloat = 8
        
        contentView.addSubview(tagView)
        tagView.addSubview(tagLabel)
        contentView.addSubview(barView)
        barView.addSubview(guageView)
        barView.addSubview(percentLabel)
        contentView.addSubview(priceLabel)
        
        
        
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        barView.translatesAutoresizingMaskIntoConstraints = false
        guageView.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        tagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        tagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        tagView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        tagView.widthAnchor.constraint(equalTo: tagView.heightAnchor).isActive = true
        
        
        
        tagLabel.centerXAnchor.constraint(equalTo: tagView.centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: tagView.centerYAnchor).isActive = true
        
        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        
        barView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        barView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        barView.leadingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: margin).isActive = true
        barView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -margin).isActive = true
//        barView.backgroundColor = .green
        
        guageView.topAnchor.constraint(equalTo: barView.topAnchor, constant: margin * 2).isActive = true
        guageView.leadingAnchor.constraint(equalTo: barView.leadingAnchor).isActive = true
        guageView.heightAnchor.constraint(equalToConstant: margin).isActive = true
        
        guageWidth = guageView.widthAnchor.constraint(equalTo: barView.widthAnchor)
        guageWidth.isActive = true
        guageView.layer.cornerRadius = 4
        
        percentLabel.bottomAnchor.constraint(equalTo: barView.bottomAnchor, constant: -margin * 2).isActive = true
        percentLabel.leadingAnchor.constraint(equalTo: barView.leadingAnchor).isActive = true
        
        
        
//        print(percent)
        
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        tagView.layer.cornerRadius = (contentView.bounds.height - (8 * 2)) / 2
        
        guageWidth.isActive = false
        guageWidth = guageView.widthAnchor.constraint(equalTo: barView.widthAnchor, multiplier: percent)
        guageWidth.isActive = true
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        let tempPercent = percent * 100
        guard let percentText = formatter.string(from: tempPercent as NSNumber) else {
            percentLabel.text = "0%"
            return
        }
        percentLabel.text = "\(percentText)%"
        
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
