//
//  BudgetViewController.swift
//  HousekeepingBook
//
//  Created by 박지승 on 2020/01/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
// 월별 컨트롤러 -> 월 예산 설정 컨트롤러

protocol BudgitViewControllerDelegate: class {
    func setBudget(budget: Int)
}

class BudgetViewController: UIViewController {

    private let textField = UITextField()
    private let guideLine = UILabel()
    private let button = UIButton()
    weak var delegate: BudgitViewControllerDelegate?
    var date = Date()
    var budget: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        baseUI()
        layout()
        textField.delegate = self
        
        setTextField()
    }
    
    private func setTextField() {
        guard let budget = budget else {
            return
        }
        textField.text = "\(budget)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @objc func buttonAction(button: UIButton) {
        
        guard let text = textField.text else { return }
        guard let money = Int(text) else { return }
        
        DataPicker.shared.setMonthBuget(month: date, budget: money)
        delegate?.setBudget(budget: money)
        
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    private func baseUI() {
        
        textField.placeholder = "예산을 입력하세요"
        textField.font = UIFont.systemFont(ofSize: 30, weight: .thin)
        textField.textAlignment = NSTextAlignment.center
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        
        guideLine.backgroundColor = MyColors.yellow
        
        button.setTitle("예산 설정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
//        button.setTitleColor(MyColors.yellow, for: .normal)
        button.backgroundColor = MyColors.yellow
        button.layer.cornerRadius = 10
        button.layer.shadowColor = ColorZip.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
//        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
        
        view.addSubview(textField)
        view.addSubview(guideLine)
        view.addSubview(button)
    }
    
    private func layout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        guideLine.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        textField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        textField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        guideLine.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        guideLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -30).isActive = true
        guideLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 30).isActive = true
        guideLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 120).isActive = true
        button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1).isActive = true
    }
}

extension BudgetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
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
