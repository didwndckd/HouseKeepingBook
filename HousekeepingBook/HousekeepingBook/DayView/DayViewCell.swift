//
//  DayViewCellTableViewCell.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DayViewCell: UITableViewCell {
    
    private let tagView = UILabel()
    private let memoView = UILabel()
    private let priceView = UILabel()
    private var _tagText = "" {
        willSet {
            tagView.text = newValue
        }
    }
    var tagText: String? {
        get {
            return _tagText
        }
        set {
            guard let text = newValue else {return}
            guard let tagModel = TagData.tags[text] else {return}
            _tagText = tagModel.name
            tagView.backgroundColor = tagModel.color
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    
    
    
    private func setupUI() {
        let margin: CGFloat = 8
        contentView.addSubview(tagView)
        contentView.addSubview(memoView)
        contentView.addSubview(priceView)
        
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        tagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        tagView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        tagView.widthAnchor.constraint(equalTo: tagView.heightAnchor).isActive = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
