//
//  DateHeader.swift
//  HousekeepingBook
//
//  Created by 박지승 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateHeader: JTACMonthReusableView {
    
    static let identifier = "DateHeader"
    
    let dateHeader = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        dateHeader.textAlignment = .center
        
        self.addSubview(dateHeader)
        
        dateHeader.translatesAutoresizingMaskIntoConstraints = false
        dateHeader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateHeader.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
