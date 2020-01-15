//
//  SelectedView.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SelectedView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
}
