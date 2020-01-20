//
//  DayCostViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

private struct Standard {
    static let spaceTB: CGFloat = 50
    static let spaceLR: CGFloat = 30
}

protocol DayCostViewControllerDelegat: class {
    func checkAction(cost: CostModel)
}

// 일별 추가버튼 클릭시
class DayCostViewController: UIViewController {
    
    weak var delegate: DayCostViewControllerDelegat?
    var tagKey: TagKey?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
       self.view.endEditing(true)
    }
    
    // MARK: - Property
    var priceTextFieldTopAnchor: NSLayoutConstraint?
    
    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "사용 금액"
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.textAlignment = .center
        return textField
    }()
    
    private var priceTextLine: UIView = {
        let moneyLine = UIView()
        moneyLine.backgroundColor = MyColors.yellow
        return moneyLine
    }()
    
    private lazy var tagButtonView: TagButtonView = {
        let temp = TagButtonView(buttonSize: 0, fontSize: 0, cornerRadius: 0)
        temp.delegate = self
        return temp
    }()
    
    private var checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.setTitle("✓", for: .normal)
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: Standard.spaceTB)
        checkButton.backgroundColor = MyColors.yellow
        checkButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return checkButton
    }()
    
    lazy private var memoTextField: UITextField = {
        let memoTextField = UITextField()
        memoTextField.borderStyle = .none
        memoTextField.placeholder = "  MEMO - 최대 10자까지"
        memoTextField.delegate = self
        return memoTextField
    }()
    
    lazy private var memoTextLine: UILabel = {
        let memoLine = UILabel()
        memoLine.backgroundColor = ColorZip.lightGray
        return memoLine
    }()
    
    private var memoView: UIView = {
        let memoView = UIView()
        memoView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
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
        
        selectedTagViewLayout()
        
        
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
        
    }
    
    @objc func keyboardWillShow() {
        UIView.animate(withDuration: 0.5, animations: {
            self.priceTextFieldTopAnchor?.constant = 5
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func keyBoardWillHideNo() {
        UIView.animate(withDuration: 0.5, animations: {
            self.priceTextFieldTopAnchor?.constant = Standard.spaceTB
            self.view.layoutIfNeeded()
        })
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        checkButton.layer.cornerRadius = checkButton.frame.width/2
    }
    
    private func selectedTagViewLayout() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(priceTextField)
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTextFieldTopAnchor = priceTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Standard.spaceTB)
        priceTextFieldTopAnchor?.isActive = true
        NSLayoutConstraint.activate([
            priceTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            priceTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Standard.spaceLR),
            priceTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Standard.spaceLR)
        ])
        
        view.addSubview(priceTextLine)
        priceTextLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceTextLine.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 3),
            priceTextLine.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            priceTextLine.widthAnchor.constraint(equalTo: priceTextField.widthAnchor),
            priceTextLine.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        view.addSubview(tagButtonView)
        tagButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagButtonView.topAnchor.constraint(equalTo: priceTextLine.bottomAnchor, constant: Standard.spaceTB),
            tagButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Standard.spaceLR),
            tagButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Standard.spaceLR),
        ])
        
        view.addSubview(memoTextField)
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoTextField.topAnchor.constraint(equalTo: tagButtonView.bottomAnchor, constant: Standard.spaceLR),
            memoTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            memoTextField.widthAnchor.constraint(equalTo: priceTextLine.widthAnchor),
            memoTextField.heightAnchor.constraint(equalToConstant: Standard.spaceLR)
        ])
        
        view.addSubview(memoTextLine)
        memoTextLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoTextLine.topAnchor.constraint(equalTo: memoTextField.bottomAnchor),
            memoTextLine.leadingAnchor.constraint(equalTo: memoTextField.leadingAnchor),
            memoTextLine.trailingAnchor.constraint(equalTo: memoTextField.trailingAnchor),
            memoTextLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        view.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.topAnchor.constraint(equalTo: memoTextLine.bottomAnchor, constant: Standard.spaceLR),
            checkButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor)
        ])
    }
    
    @objc private func didTapButton(_ sender: TagButton) {
        guard let tag = tagKey else {
            appearAlert()
            return
        }
        let memo = memoTextField.text ?? ""
        guard let money = priceTextField.text, let price = Int(money) else {
            appearAlert()
            return
            
        }
        
        let cost = CostModel(tag: tag.rawValue, memo: memo, price: price)
        delegate?.checkAction(cost: cost)
        dismiss(animated: true)
    }
    
    private func appearAlert() {
        let alertController = UIAlertController(title: "금액 또는 태그를 입력해주세요.",
                                                message: "",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
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
        } else if textField == self.priceTextField {
            if let _ = Int(string) {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - 첫번째 버튼 바로 안눌리는 거 업스한테 물어봐야 함
extension DayCostViewController: TagButtonViewDelegate {
    func tagButtonsDidTap(tagKey: TagKey) {
        self.tagKey = tagKey
    }
}
