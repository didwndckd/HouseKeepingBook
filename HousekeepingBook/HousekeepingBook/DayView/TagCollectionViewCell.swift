//
//  TagCollectionViewCell.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//
import UIKit

protocol TagCollectionViewCellDelegate: class {
  func didTapTagButtonAction(tagKey: String?)
}

class TagCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "TagCollectionViewCell"
  
    let tagButton = TagButton(type: .system)
    weak var delegate: TagCollectionViewCellDelegate?
    private var tagKey: String?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    tagButton.tintColor = .white
    tagButton.titleLabel?.font = .systemFont(ofSize: 23, weight: .bold)
    contentView.addSubview(tagButton)
    
    tagButton.translatesAutoresizingMaskIntoConstraints = false
    tagButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    tagButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    tagButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    tagButton.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(tagKey: TagKey) {
    let key = tagKey.rawValue
    guard let tag = TagData.tags[key] else {return}
    contentView.backgroundColor = tag.color
    tagButton.setTitle(tag.name, for: .normal)
    self.tagKey = key
    tagButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
  }
    
    @objc private func didTapButton(sender: TagButton) {
      delegate?.didTapTagButtonAction(tagKey: tagKey)
      self.contentView.shadow()
    }
    
    
}
