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
    textField.borderStyle = .none
    textField.keyboardType = .numberPad
    textField.font = UIFont(name: "Arial", size: 33)
    textField.textAlignment = .center
    
    return textField
  }()
  
  private var moneyLine: UIView = {
    let moneyLine = UIView()
    moneyLine.backgroundColor = ColorZip.midiumPink
    return moneyLine
  }()
  
  private lazy var vTagButton: TagButtonView = {
    let temp = TagButtonView(buttonSize: 0, fontSize: 0, cornerRadius: 0)
    temp.delegate = self
    return temp
  }()
  
  private var checkButton: UIButton = {
    let checkButton = UIButton()
    checkButton.setTitle(" Check ", for: .normal)
    checkButton.setTitleColor(.white, for: .normal)
    checkButton.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.8156862745, blue: 0.3490196078, alpha: 1)
    checkButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    checkButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
    checkButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    checkButton.layer.cornerRadius = 10
    return checkButton
  }()
  
  lazy private var memoTextField: UITextField = {
    let memoTextField = UITextField()
    memoTextField.delegate = self
    memoTextField.borderStyle = .none
    //    memoTextField.keyboardType = .
    memoTextField.font = UIFont(name: "Arial", size: 20)
    memoTextField.textAlignment = .left
    memoTextField.placeholder = "MEMO:"
    return memoTextField
  }()
  
  private var memoView: UIView = {
    let memoView = UIView()
    memoView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    memoView.layer.cornerRadius = 20
    return memoView
  }()
  
  // ₩
  let sumLabel: UILabel = {
    let sumLabel = UILabel()
    sumLabel.backgroundColor = .white
    sumLabel.textColor = ColorZip.lightGray
    sumLabel.text = "₩"
    sumLabel.textAlignment = .left
    sumLabel.font = UIFont.systemFont(ofSize: 35)
    return sumLabel
  }()
  
  
  
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    configureCollectionView()
  }
  
  private func configureCollectionView() {
    
//    view.addSubview(collectionView)
//    collectionView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
//      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//      //      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//      collectionView.heightAnchor.constraint(equalToConstant: 300),
//      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//    ])
    view.addSubview(vTagButton)
    vTagButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vTagButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
      vTagButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      //      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//      vTagButton.heightAnchor.constraint(equalToConstant: 300),
      vTagButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
    
    
    view.addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Standard.space - 10),
      textField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      textField.widthAnchor.constraint(equalToConstant: 230),
      textField.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    view.addSubview(moneyLine)
    moneyLine.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moneyLine.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
      moneyLine.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      moneyLine.widthAnchor.constraint(equalToConstant: 230),
      moneyLine.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    view.addSubview(checkButton)
    checkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkButton.topAnchor.constraint(equalTo: vTagButton.bottomAnchor, constant: 30),
      checkButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      //checkButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      //checkButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
    ])
    
    view.addSubview(sumLabel)
    sumLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sumLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Standard.space - 10),
      sumLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 5),
    ])
    
    view.addSubview(memoView)
    memoView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      memoView.topAnchor.constraint(equalTo: moneyLine.bottomAnchor, constant: Standard.space - 13),
      memoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      memoView.widthAnchor.constraint(equalToConstant: 320),
      memoView.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    memoView.addSubview(memoTextField)
    memoTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      memoTextField.topAnchor.constraint(equalTo: memoView.topAnchor),
      memoTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      memoTextField.widthAnchor.constraint(equalToConstant: 300),
      memoTextField.heightAnchor.constraint(equalToConstant: 40)
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
  
  private struct Standard {
    static let space: CGFloat = 30
  }
  
}


// MARK: - UICollectionViewDataSource

extension DayCostViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if string.isEmpty {
      return true
    }
    if textField == memoTextField {
      return true
    } else if textField == self.textField {
      if let _ = Int(string) {
        return true
      } else {
        return false
      }
    }
    return true
  }
}

extension DayCostViewController: TagCollectionViewCellDelegate {
  func didTapTagButtonAction(tagKey: String?) {
    self.tagKey = tagKey
    
    guard let tagModel = TagData.tags[tagKey!] else { return }
    let tagData = tagModel
    print("didTapTagButtonAction", tagData.name)
  }
  
  
  
}

extension DayCostViewController: TagButtonViewDelegate {
  func tagButtonsDidTap(tagKey: String) {
    self.tagKey = tagKey
  }
}
