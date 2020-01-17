//
//  TagButtonView.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol TagButtonViewDelegate: class {
  func tagButtonsDidTap(tagKey: TagKey)
}

class TagButtonView: UIView {
  
  struct Padding {
    static let inset: CGFloat = 16
    static let buttonXSpace: CGFloat = 40
    static let buttonYSpace: CGFloat = 8
    static let buttonSize: CGFloat = 70
  }
  
  weak var delegate: TagButtonViewDelegate?
  
  private var tagButtons = [UIButton]()
  private var selectButtonTag = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(buttonSize: CGFloat, fontSize: CGFloat, cornerRadius: CGFloat) {
    self.init()
    self.createTagButton(buttonSize: buttonSize, fontSize: fontSize, cornerRadius: cornerRadius)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createTagButton(buttonSize: CGFloat, fontSize: CGFloat, cornerRadius: CGFloat) {
    for (index, value) in TagData.tagHeads.enumerated() {
      let tempButton = TagButton(tagKey: value)
      tagButtons.append(tempButton)
      tempButton.tag = index
      tempButton.layer.cornerRadius = 35 + cornerRadius
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 + fontSize, weight: .medium)
      tempButton.setTitle(TagData.tags[value.rawValue]?.name, for: .normal)
      tempButton.setTitleColor(.white, for: .normal)
      tempButton.backgroundColor = TagData.tags[value.rawValue]?.color
      tempButton.addTarget(self, action: #selector(tagButtonAction(_:)), for: .touchUpInside)
      self.addSubview(tempButton)
      tempButton.translatesAutoresizingMaskIntoConstraints = false
      tempButton.widthAnchor.constraint(equalToConstant: Padding.buttonSize + buttonSize).isActive = true
      tempButton.heightAnchor.constraint(equalToConstant: Padding.buttonSize + buttonSize).isActive = true
    }
    
    for (index, button) in tagButtons.enumerated() {
      switch index % 3 {
      case 0:
        button.trailingAnchor.constraint(equalTo: tagButtons[1].leadingAnchor, constant: -Padding.buttonXSpace).isActive = true
      case 1:
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
      default:
        button.leadingAnchor.constraint(equalTo: tagButtons[1].trailingAnchor, constant: Padding.buttonXSpace).isActive = true
      }
    }
    
    for button in tagButtons[0...2] {
      button.topAnchor.constraint(equalTo: self.topAnchor, constant: Padding.inset).isActive = true
    }
    
    for button in tagButtons[3...5] {
      button.topAnchor.constraint(equalTo: tagButtons[0].bottomAnchor, constant: Padding.buttonYSpace).isActive = true
    }
    
    for button in tagButtons[6...8] {
      button.topAnchor.constraint(equalTo: tagButtons[3].bottomAnchor, constant: Padding.buttonYSpace).isActive = true
      button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Padding.inset).isActive = true
    }
  }
  @objc private func tagButtonAction(_ sender: TagButton) {
    tagButtons[sender.tag].shadow()
    tagButtons[selectButtonTag].unShadow()
    selectButtonTag = sender.tag
    
    delegate?.tagButtonsDidTap(tagKey: sender.tagKey)
  }
  
}
