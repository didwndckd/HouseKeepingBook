//
//  DayCostViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol DayCostViewControllerDelegat: class {
    func checkAction(cost: CostModel)
}

// 일별 추가버튼 클릭시
class DayCostViewController: UIViewController {
  
    
    weak var delegate: DayCostViewControllerDelegat?
    var tagKey: String?
    
  // MARK: - CollectionViewMetric
    
  private enum Metric {
    static let lineSpacing: CGFloat = 30
    static let itemSpacing: CGFloat = 3
    static let nextOffSet: CGFloat = 40
    
    static let numberOfLine: CGFloat = 3
    static let numberOfItem: CGFloat = 3
    
    // 컬렉션뷰의 안쪽의 간격 (틀?)
    static let inset: UIEdgeInsets = .init(top: 10, left: 40, bottom: 10, right:10 )
    
    static var horizontalPadding: CGFloat {
      return Metric.inset.left + Metric.inset.right
    }
    
    static var verticalPadding: CGFloat {
      return Metric.inset.top + Metric.inset.bottom
    }
  }
  
  // MARK: - Property
  
  lazy var textField: UITextField = {
    let textField = UITextField()
    textField.delegate = self
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = UIFont(name: "Arial", size: 28)
    textField.textAlignment = .center
    return textField
  }()
  
  lazy private var collectionView: UICollectionView = {
    // layout
    let layout = UICollectionViewFlowLayout()
    // 가로, 세로로 보여짐
    layout.scrollDirection = .horizontal
    
    // view
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    
    return collectionView
  }()
  
  lazy private var checkButton: UIButton = {
    let checkButton = UIButton()
    checkButton.setTitle(" Check ", for: .normal)
    checkButton.setTitleColor(.white, for: .normal)
    checkButton.backgroundColor = #colorLiteral(red: 0.5056351423, green: 0.6657808423, blue: 1, alpha: 1)
    checkButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    checkButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
    checkButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    checkButton.layer.cornerRadius = 10
    return checkButton
  }()
  
  
  
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    configureCollectionView()
  }
  
  private func configureCollectionView() {
    
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: 300),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
    
    view.addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      textField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      textField.widthAnchor.constraint(equalToConstant: 300),
      textField.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    view.addSubview(checkButton)
    checkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
      checkButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      //checkButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      //checkButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
    ])
    
    
  }

      @objc private func didTapButton(_ sender: TagButton) {
        
        guard let tag = tagKey else {
            appearAlert()
            return
        }
        
        let cost = CostModel(tag: tag, memo: "test", price: 1000)
        delegate?.checkAction(cost: cost)
        dismiss(animated: true)
      }
    
    private func appearAlert() {
        let alertController = UIAlertController()
        let okAction = UIAlertAction(title: "태그를 골라주세요.", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
  
}


// MARK: - UICollectionViewDataSource

extension DayCostViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return TagData.tags.count }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else { fatalError() }
    let key = TagData.tagHeads[indexPath.row]
    
    cell.configure(tagKey: key)
    cell.delegate = self
    
    return cell
  }
}

extension DayCostViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let lineSpacing = Metric.lineSpacing * (Metric.numberOfLine - 1)
    let horizontalPadding = Metric.inset.left + Metric.inset.right + Metric.nextOffSet
    
    let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
    let verticalPadding = Metric.inset.top + Metric.inset.bottom
    
    let width = (collectionView.frame.width - lineSpacing - horizontalPadding) / Metric.numberOfLine
    let height = (collectionView.frame.height - itemSpacing - verticalPadding) / Metric.numberOfItem
    
    return CGSize(width: width.rounded(.down), height: height.rounded(.down))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.lineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.itemSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return Metric.inset
  }
  
  // 버튼 클릭시 해당셀에 뭐가눌린지 알 수 있음
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let key = TagData.tagHeads[indexPath.row].rawValue
    guard let tagModel = TagData.tags[key] else { return }
    let tagData = tagModel
    print(tagData.name)
  }
  
}

extension DayCostViewController: UITextFieldDelegate {
  
}

extension DayCostViewController: TagCollectionViewCellDelegate {
    func didTapTagButtonAction(tagKey: String?) {
        
        self.tagKey = tagKey
        
    }
    
    
}

