//
//  CostModel.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

class CostModel: Codable {
    
    let tag: String
    let memo: String
    let price: Int
    
    init(tag: String, memo: String, price: Int) {
        self.tag = tag
        self.memo = memo
        self.price = price
    }
}
