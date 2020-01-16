//
//  CostDetailViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class CostDetailViewController: UIViewController {
  
  // MARK: - Property
  private let baseView = UIView()
  private let mainLabel = UILabel()
  private let dateLabel = UILabel()
  private let trashButton = UIButton()
  private let tagImage = UIImage()
  private let sumLabel = UILabel()
  private let totalLabel = UILabel()
  private let totalLine = UIView()
  
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    alertAutolayoutUI()
    baseUI()
  }
  
  private func alertAutolayoutUI() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    
    let guide = view.safeAreaLayoutGuide
    
    let baseViewWidth = view.frame.width - 100
    let baseViewHeight = view.frame.height - 250
    view.addSubview(baseView)
    baseView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      baseView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      baseView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
      baseView.heightAnchor.constraint(equalToConstant: baseViewHeight),
      baseView.widthAnchor.constraint(equalToConstant: baseViewWidth),
    ])
    
    baseView.addSubview(mainLabel)
    mainLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      mainLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
      mainLabel.heightAnchor.constraint(equalToConstant: baseViewHeight),
      mainLabel.widthAnchor.constraint(equalToConstant: baseViewWidth),
    ])
    
    
    
    
    
  }
  
  private func baseUI() {
    baseView.backgroundColor = .white
  }
}

