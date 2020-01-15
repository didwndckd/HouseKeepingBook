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
    
     static let tags: [TagKey: TagModel] = [
        TagKey.foodTag: TagModel(name: "식사", color:  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),//1
        TagKey.transTag: TagModel(name: "교통", color:  #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),//3
        TagKey.phoneTag: TagModel(name: "통신", color:  #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),//6
        TagKey.billTag: TagModel(name: "공과금", color:  #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)),//5
        TagKey.giftTag: TagModel(name: "선물", color:  #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),//4
        TagKey.beautyTag: TagModel(name: "미용", color:  #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)),//2
        TagKey.interestTag: TagModel(name: "이자", color:  #colorLiteral(red: 0.3694096804, green: 1, blue: 0.9938061833, alpha: 1)),//7
        TagKey.saveMoneyTag: TagModel(name: "저금", color:  #colorLiteral(red: 1, green: 0.3806025088, blue: 0.9558392167, alpha: 1)),//6
        TagKey.etcTage: TagModel(name: "기타", color:  #colorLiteral(red: 1, green: 0.9558901191, blue: 0.9044175148, alpha: 1)),//8
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


