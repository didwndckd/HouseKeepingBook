//
//  ExtensionUIView.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UIView {
  func shadow() {
    self.layer.shadowRadius = 8.0
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = .zero
    self.layer.shadowColor = UIColor.darkGray.cgColor
  }
  
  func unShadow() {
    self.layer.shadowRadius = 0
    self.layer.shadowOpacity = 0
    self.layer.shadowOffset = .zero
    self.layer.shadowColor = UIColor.clear.cgColor
  }
}
