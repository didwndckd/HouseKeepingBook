//
//  TagModel.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//


import UIKit

struct TagModel {
    let name: String
    let color: UIColor
}



enum TagKey: String {
    case foodTag, transTag, phoneTag, billTag, giftTag, beautyTag, interestTag, saveMoneyTag, etcTage
}


struct TagData {
    // 식비, 교통비, 휴대폰비, 공과금, 선물, 미용, 이자, 저금, 기타,
    
     static let tags: [String: TagModel] = [
        TagKey.foodTag.rawValue: TagModel(name: "식사", color:  #colorLiteral(red: 0.6341673732, green: 0.8130221963, blue: 0.9294165969, alpha: 1)),//1
        TagKey.transTag.rawValue: TagModel(name: "교통", color:  #colorLiteral(red: 0.9764111638, green: 0.9074609876, blue: 0.8522706628, alpha: 1)),//3
        TagKey.phoneTag.rawValue: TagModel(name: "통신", color:  #colorLiteral(red: 0.8951025605, green: 0.7146639824, blue: 0.8171000481, alpha: 1)),//6
        TagKey.billTag.rawValue: TagModel(name: "공과금", color:  #colorLiteral(red: 0.1268284619, green: 0.6526806951, blue: 0.7871559262, alpha: 1)),//5
        TagKey.giftTag.rawValue: TagModel(name: "선물", color:  #colorLiteral(red: 0.02159192972, green: 0.4183322191, blue: 0.6206336617, alpha: 1)),//4
        TagKey.beautyTag.rawValue: TagModel(name: "미용", color:  #colorLiteral(red: 0.4928416014, green: 0.884049952, blue: 0.8057829738, alpha: 1)),//2
        TagKey.interestTag.rawValue: TagModel(name: "이자", color:  #colorLiteral(red: 0.7262660861, green: 0.5991876721, blue: 0.7680996656, alpha: 1)),//7
        TagKey.saveMoneyTag.rawValue: TagModel(name: "저금", color:  #colorLiteral(red: 0.6071969867, green: 0.5970490575, blue: 0.932897985, alpha: 1)),//6
        TagKey.etcTage.rawValue: TagModel(name: "기타", color:  #colorLiteral(red: 0.6328347325, green: 0.6880624294, blue: 0.7724642158, alpha: 1)),//8
    ]
    
    
    //태그의 키들을 정렬해놓은 배열(전체다 뺄때는 이 순서로 빼시면 됩니다)
    static let tagHeads = [
        TagKey.foodTag,
        TagKey.beautyTag,
        TagKey.transTag,
        TagKey.giftTag,
        TagKey.billTag,
        TagKey.phoneTag,
        TagKey.saveMoneyTag,
        TagKey.interestTag,
        TagKey.etcTage,
    ]
        
}


