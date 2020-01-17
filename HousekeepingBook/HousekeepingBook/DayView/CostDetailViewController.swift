//
//  CostDetailViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

/*
추가 기능 :
 - Memo도 수정할 수 있도록 TextField여야 함
 - 메모, 금액 적정 간격 (안정적인 구조)
 - 리턴키 누르면 키보드 내려감
 - 키보드 외 화면키 누르면 키보드 내려감
 - tagbutton
 */

import UIKit

class CostDetailViewController: UIViewController {
  
  // MARK: - Property
  var date: Date?
  var tag: TagKey = .foodTag
  var memo = "Memo Test!!"
  var price = -1
  private let baseView = UIView()
  private let mainLabel = UILabel()
  private let dateLabel = UILabel()
  private let tagImage = UIImage()
  private let sumLabel = UILabel()
  private let totalTextField = UITextField()
  private let totalLine = UIView()
  private let memoLabel = UILabel()
  private var memoView = UIView()
  private let tagButton = UIButton()
  private var toggle = false
  

  // MARK: - vTagButton
  private lazy var vTagButton: TagButtonView = {
    let button = TagButtonView(buttonSize: -20, fontSize: -7, cornerRadius: -10)
//    temp.delegate = self
    return button
  }()
  
  private let trashButton: UIButton = {
    let button = UIButton()
    let closeImage = UIImage(systemName: "trash")
    button.setImage(closeImage, for: .normal)
    button.setPreferredSymbolConfiguration(.init(scale: .default), forImageIn: .normal)
    button.tintColor = .systemPink
//        button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
    return button
  }()
  private let closeButton: UIButton = {
    let button = UIButton()
    let closeImage = UIImage(systemName: "xmark")
    button.setImage(closeImage, for: .normal)
    button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
    button.tintColor = ColorZip.midiumGray
        button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
    return button
  }()
  var constraint: NSLayoutConstraint!
  
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyBoardWillHideNo),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
    
    alertAutolayoutUI()
    baseUI()
  }
  
  
  @objc func keyBoardWillHideNo(_ notification: Notification) {
    constraint.constant = -(view.frame.height / 4)
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          let keyboardRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 0.5, animations: {
          self.constraint.constant = -(keyboardHeight + 24)
          self.view.layoutIfNeeded()
        })
        // 301.0 keyboard height
      }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    view.endEditing(true)
  }
  
  
    // MARK: - Anchor
  private func alertAutolayoutUI() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    
    let guide = view.safeAreaLayoutGuide
    constraint = baseView.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
    let baseViewWidth = view.frame.width - 100
    let baseViewHeight = view.frame.height / 1.8
    view.addSubview(baseView)
    baseView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      baseView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      baseView.heightAnchor.constraint(equalToConstant: baseViewHeight),
      baseView.widthAnchor.constraint(equalToConstant: baseViewWidth),
    ])
    
    constraint = baseView.bottomAnchor.constraint(equalTo:view.bottomAnchor , constant: -(baseViewHeight / 2))
    constraint.isActive = true
    
    baseView.addSubview(mainLabel)
    mainLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      mainLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: Padding.ySpace),
    ])
    
    baseView.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      dateLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: Padding.ySpace - 15),
    ])
    
    baseView.addSubview(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5),
      closeButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -5)
    ])
    
    baseView.addSubview(totalTextField)
    totalTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      totalTextField.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -Padding.ySpace * 2),
      totalTextField.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      totalTextField.widthAnchor.constraint(equalToConstant: 230),
      totalTextField.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    baseView.addSubview(totalLine)
     totalLine.translatesAutoresizingMaskIntoConstraints = false
     NSLayoutConstraint.activate([
       totalLine.bottomAnchor.constraint(equalTo: totalTextField.bottomAnchor),
       totalLine.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
       totalLine.widthAnchor.constraint(equalToConstant: 230),
       totalLine.heightAnchor.constraint(equalToConstant: 1)
     ])
    
    baseView.addSubview(sumLabel)
    sumLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sumLabel.bottomAnchor.constraint(equalTo: totalLine.bottomAnchor),
      sumLabel.leadingAnchor.constraint(equalTo: totalLine.leadingAnchor),
    ])
    
    baseView.addSubview(trashButton)
    trashButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      trashButton.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 5),
      trashButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 5)
    ])
    
    baseView.addSubview(tagButton)
    tagButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tagButton.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 150),
      tagButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      tagButton.widthAnchor.constraint(equalToConstant: Padding.buttonSize - 20),
      tagButton.heightAnchor.constraint(equalToConstant: Padding.buttonSize - 20),
      
    ])
    
    baseView.addSubview(memoView)
    memoView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      memoView.bottomAnchor.constraint(equalTo: totalTextField.topAnchor, constant: -10),
      memoView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      memoView.widthAnchor.constraint(equalToConstant: 220),
      memoView.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    memoView.addSubview(memoLabel)
    memoLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      memoLabel.topAnchor.constraint(equalTo: memoView.topAnchor),
      memoLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
      memoLabel.widthAnchor.constraint(equalToConstant: 200),
      memoLabel.heightAnchor.constraint(equalToConstant: 24)
    ])
    
    // MARK: - vTagButton
    baseView.addSubview(vTagButton)
    vTagButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vTagButton.topAnchor.constraint(equalTo: memoView.topAnchor),
      vTagButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
      //      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      //      vTagButton.heightAnchor.constraint(equalToConstant: 300),
      vTagButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
    ])
  }
  
  // MARK: - baseUI
  private func baseUI() {
    baseView.backgroundColor = .white
    
    mainLabel.text = "Receipt"
    mainLabel.textAlignment = .center
    mainLabel.textColor = #colorLiteral(red: 0.9921568627, green: 0.8156862745, blue: 0.3490196078, alpha: 1)
    mainLabel.font = .systemFont(ofSize: 40, weight: .black)
    
    dateLabel.text = "2020.01.10(Sat)"
    dateLabel.textAlignment = .center
    dateLabel.textColor = #colorLiteral(red: 0.9921568627, green: 0.8156862745, blue: 0.3490196078, alpha: 1)
    dateLabel.backgroundColor = ColorZip.midiumGray
    dateLabel.font = .systemFont(ofSize: 18, weight: .light)
    
    totalTextField.borderStyle = .none
    totalTextField.font = .systemFont(ofSize: 25, weight: .light)
    totalTextField.textAlignment = .center
    totalTextField.delegate = self
    totalTextField.keyboardType = .numberPad
    
    totalLine.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.8156862745, blue: 0.3490196078, alpha: 1)
    
    sumLabel.backgroundColor = .white
    sumLabel.textColor = ColorZip.midiumGray
    sumLabel.text = "₩"
    sumLabel.textAlignment = .left
    sumLabel.font = UIFont.systemFont(ofSize: 35)
    
    vTagButton.alpha = 0
    
    tagButton.setTitle(TagData.tags[TagKey.beautyTag.rawValue]?.name, for: .normal)
    tagButton.setTitleColor(.white, for: .normal)
    tagButton.backgroundColor = TagData.tags[TagKey.beautyTag.rawValue]?.color
    tagButton.addTarget(self, action: #selector(didTapTagButton(_:)), for: .touchUpInside)
    tagButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
    tagButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    
    memoLabel.font = UIFont(name: "Arial", size: 16)
    memoLabel.textAlignment = .center
    memoLabel.text = self.memo
    
    memoView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
  
  }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tagButton.layer.cornerRadius = tagButton.frame.width/2
    }
   
  
  
  @objc private func didTapCloseButton(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
  @objc private func didTapTagButton(_ sender: UIButton) {

    if toggle == false {
    UIView.animate(
      withDuration: 0.8,
      animations: {
        self.tagButton.alpha = 0
        self.vTagButton.alpha = 1
        self.vTagButton.center.y -= 240
        self.toggle = true
    })
    } else {
      UIView.animate(
        withDuration: 0.8,
        animations: {
          self.vTagButton.alpha = 0
          self.vTagButton.center.y += 240
      })
    }
    
    
  }
  
  struct Padding {
    static let buttonSize: CGFloat = 80
    static let ySpace: CGFloat = 30
//    static let buttonSize: CGFloat = 80
  }
}

  // MARK: - UITextFieldDelegate
extension CostDetailViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      if string.isEmpty {
          return true
      }
      if let _ = Int(string){
          return true
      } else {
          return false
      }
  }
}
