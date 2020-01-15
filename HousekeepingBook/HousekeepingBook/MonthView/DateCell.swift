//
//  DateCell.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import JTAppleCalendar
import UIKit

class DateCell: JTACDayCell {
     let dateLabel = UILabel()
     let selectedView = SelectedView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        dateLabel.textAlignment = .center
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        selectedView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        selectedView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    
}
