//
//  CostDetailViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol CostDetailViewControllerDelegate: class {
    func deleteAction(position: IndexPath?, price: Int)
    func updateActiom(position: IndexPath?, data: CostModel)
}

class CostDetailViewController: UIViewController {
    
    // MARK: - Property
    var position: IndexPath?
    var date: Date?
    var _tag = ""
    var tag: String {
        get {
            return  _tag
        }
        set{
            _tag = newValue
            let titleTag = TagData.tags[newValue]
            tagButton.setTitle(titleTag?.name, for: .normal)
            tagButton.backgroundColor = titleTag?.color
        }
    }
    
    
    var memo: String = "" {
        willSet {
            memoTextField.text = newValue
        }
    }
    
    
    
    
    weak var delegate: CostDetailViewControllerDelegate?
    var price = -1 {
        didSet {
            totalTextField.text = "\(price)"
        }
    }
    private let baseView = UIView()
    private let receiptLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let tagButton = UIButton()
    
    private var memoView = UIView()
    private let memoTextField = UITextField()
    
    private let totalLabel = UILabel()
    private let totalTextField = UITextField()
    private let totalLine = UIView()
    
    private let okButton = UIButton()
    
    private var toggle = false
    
    
    // MARK: - vTagButton
    private lazy var vTagButton: TagButtonView = {
        let button = TagButtonView(buttonSize: -20, fontSize: -7, cornerRadius: -10)
        button.delegate = self
        //    temp.delegate = self
        return button
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton()
        let closeImage = UIImage(systemName: "trash")
        button.setImage(closeImage, for: .normal)
        button.setPreferredSymbolConfiguration(.init(scale: .default), forImageIn: .normal)
        button.tintColor = .systemPink
        button.addTarget(self, action: #selector(didTrashButton(_:)), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(date)
        
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
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd"
            let timeStemp = formatter.string(from: date)
            dateLabel.text = timeStemp
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tagButton.layer.cornerRadius = tagButton.frame.width/2
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
    
    @objc private func didTrashButton(_ sender: UIButton) {
        // MARK: -  ################ 중창 - 삭제 액션 완료^^
        delegate?.deleteAction(position: position, price: price)
        
        dismiss(animated: true)
    }
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        
       
        dismiss(animated: true)
    }
    
    @objc private func didTapTagButton(_ sender: UIButton) {
        animationTagButton()
    }
    
    private func animationTagButton() {
        var temp:CGFloat = 0
        if toggle == false {
            temp  = self.vTagButton.center.y
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    //                    self.tagButton.alpha = 0
                    self.vTagButton.alpha = 1
                    self.vTagButton.center.y -= self.okButton.frame.height + 8
                    self.toggle = true
            })
        } else {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.vTagButton.alpha = 0
                    self.vTagButton.center.y += temp + self.okButton.frame.height + 8
                    self.toggle = false
            })
        }
    }
    
    @objc func actionOkButton(_ button: UIButton) {
        // MARK: - ################# 중창 - 데이터 넘기기
        let tag = self.tag
        let memo = memoTextField.text ?? ""
        let price = Int(totalTextField.text ?? "") ?? self.price
        delegate?.updateActiom(position: position, data: CostModel(tag: tag, memo: memo, price: price))
        dismiss(animated: true)
        
    }
    
    struct Padding {
        static let buttonSize: CGFloat = 80
        static let ySpace: CGFloat = 30
        //    static let buttonSize: CGFloat = 80
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
        
        baseView.addSubview(receiptLabel)
        receiptLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            receiptLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            receiptLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: Padding.ySpace),
        ])
        
        baseView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: receiptLabel.bottomAnchor, constant: Padding.ySpace - 15),
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
            totalTextField.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -Padding.ySpace * 3.5),
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
        
        baseView.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalLabel.bottomAnchor.constraint(equalTo: totalLine.bottomAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: totalLine.leadingAnchor),
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
            tagButton.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 145),
            tagButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            tagButton.widthAnchor.constraint(equalToConstant: Padding.buttonSize - 20),
            tagButton.heightAnchor.constraint(equalToConstant: Padding.buttonSize - 20),
            
        ])
        
        baseView.addSubview(memoView)
        memoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoView.bottomAnchor.constraint(equalTo: tagButton.bottomAnchor, constant: 50),
            memoView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            memoView.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.7),
            memoView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        memoView.addSubview(memoTextField)
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoTextField.bottomAnchor.constraint(equalTo: memoView.bottomAnchor, constant: -2),
            memoTextField.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            memoTextField.widthAnchor.constraint(equalTo: memoView.widthAnchor, constant: -10),
            memoTextField.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        baseView.addSubview(vTagButton)
        vTagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //            vTagButton.topAnchor.constraint(equalTo: baseView.bottomAnchor),
            //      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //      vTagButton.heightAnchor.constraint(equalToConstant: 300),
            vTagButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            vTagButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            vTagButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
        ])
        
        baseView.addSubview(okButton)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -20),
            okButton.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            okButton.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    // MARK: - baseUI
    private func baseUI() {
        baseView.backgroundColor = .white
        
        receiptLabel.text = "Receipt"
        receiptLabel.textAlignment = .center
        receiptLabel.textColor = #colorLiteral(red: 0.9921568627, green: 0.8156862745, blue: 0.3490196078, alpha: 1)
        receiptLabel.font = .systemFont(ofSize: 40, weight: .black)
        
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
        
        totalLabel.backgroundColor = .white
        totalLabel.textColor = ColorZip.midiumGray
        totalLabel.text = "₩"
        totalLabel.textAlignment = .left
        totalLabel.font = UIFont.systemFont(ofSize: 35)
        
        vTagButton.alpha = 0
        vTagButton.backgroundColor = .white
        
        tagButton.setTitleColor(.white, for: .normal)
        tagButton.backgroundColor = TagData.tags[TagKey.beautyTag.rawValue]?.color
        tagButton.addTarget(self, action: #selector(didTapTagButton(_:)), for: .touchUpInside)
        tagButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        tagButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        memoTextField.delegate = self
        memoTextField.font = UIFont.systemFont(ofSize: 15)
        memoTextField.textAlignment = .center
        
        
        memoView.backgroundColor = MyColors.lightgray
        
        okButton.setTitle("✓", for: .normal)
        okButton.setTitleColor(MyColors.yellow, for: .normal)
        okButton.layer.borderWidth = 2
        okButton.layer.borderColor = MyColors.yellow.cgColor
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        okButton.addTarget(self, action: #selector(actionOkButton(_:)), for: .touchUpInside)
        
    }
}

// MARK: - UITextFieldDelegate
extension CostDetailViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self?.totalBottomConstraint?.constant = -150
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == totalTextField {
            if string.isEmpty {
                return true
            }
            if let _ = Int(string){
                return true
            } else {
                return false
            }
        }else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension CostDetailViewController: TagButtonViewDelegate {
    func tagButtonsDidTap(tagKey: TagKey) {
        self.tag = tagKey.rawValue
        animationTagButton()
    }
}
