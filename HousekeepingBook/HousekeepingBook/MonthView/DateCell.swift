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
    let todayLabel = UILabel()
    let stateImageView = UIImageView()
    
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
        contentView.addSubview(todayLabel)
        contentView.addSubview(stateImageView)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        todayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        todayLabel.isHidden = true
        todayLabel.text = ""
        todayLabel.font = .systemFont(ofSize: 8, weight: .bold)
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        selectedView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        selectedView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        
        
        // MARK: - 빛중창보시오.
        /*
         let goodState = "hand.thumbsup"
         let badState = "hand.thumbsdown"
         if 하루 예산 > 0 {
            stateImageView.image = UIImage(systemName: goodState)
            stateImageView.tintColor = MyColors.green
         } else {
            stateImageView.image = UIImage(systemName: badState)
            stateImageView.tintColor = MyColors.red
         }
         */
//        stateImageView.image = UIImage(systemName: "hand.thumbsup")
        stateImageView.tintColor = .white
        stateImageView.contentMode = .scaleAspectFit
        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        stateImageView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor).isActive = true
        stateImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stateImageView.isHidden = true
    }
    
    
}
