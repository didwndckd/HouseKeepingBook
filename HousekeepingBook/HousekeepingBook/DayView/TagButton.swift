//
//  TagButton.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TagButton: UIButton {

    var tagKey: TagKey
    
    init(tagKey: TagKey) {
        self.tagKey = tagKey
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
