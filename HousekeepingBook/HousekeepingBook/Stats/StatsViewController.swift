//
//  StatsViewController.swift
//  HousekeepingBook
//
//  Created by 박지승 on 2020/01/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// tab-bar-tag-2: 통계 컨트롤러
class StatsViewController: UIViewController {
    
    private let infoText = UILabel()
    private let presentCostView = UIView()
    private let presentCostText = UILabel()
    private let guideLine = UILabel()
    private let scrollView = UIScrollView()
    
    private var textAutolayout: NSLayoutConstraint!
    
    // MARK: - <TagData> 넣는 곳
    private let tagData = ["tag1":10000, "tag2": 2000000, "tag3": 300, "tag4": 40000, "tag5": 5000000000]
    
    private var itemViewArr = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        baseUI()
        layout()
        makeCostByTag(data: tagData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for item in itemViewArr {
            item.layer.cornerRadius = item.frame.width / 2
        }
    }
    
    private func baseUI() {
        infoText.text = "현재까지 사용 금액입니다."
        infoText.tintColor = ColorZip.midiumGray
        infoText.font = .systemFont(ofSize: 15, weight: .light)
        
        // MARK: - <<이번 달 총액 넣는 곳>>
        presentCostText.text = "100000"
        presentCostText.tintColor = .black
        presentCostText.font = .systemFont(ofSize: 40, weight: .heavy)
        presentCostText.textAlignment = .center
        presentCostText.alpha = 0.0
        
        guideLine.backgroundColor = MyColors.yellow
        
        scrollView.backgroundColor = .white
        
        view.addSubview(presentCostView)
        presentCostView.addSubview(presentCostText)
        presentCostView.addSubview(infoText)
        view.addSubview(guideLine)
        view.addSubview(scrollView)
    }
    
    private func layout() {
        infoText.translatesAutoresizingMaskIntoConstraints = false
        presentCostView.translatesAutoresizingMaskIntoConstraints = false
        presentCostText.translatesAutoresizingMaskIntoConstraints = false
        guideLine.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeLayout = view.safeAreaLayoutGuide
        
        presentCostView.topAnchor.constraint(equalTo: safeLayout.topAnchor).isActive = true
        presentCostView.heightAnchor.constraint(equalTo: safeLayout.heightAnchor, multiplier: 0.2).isActive = true
        presentCostView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor).isActive = true
        presentCostView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor).isActive = true
        
        infoText.topAnchor.constraint(equalTo: presentCostView.topAnchor, constant: 30).isActive = true
        infoText.centerXAnchor.constraint(equalTo: presentCostView.centerXAnchor).isActive = true
        
        guideLine.topAnchor.constraint(equalTo: presentCostView.bottomAnchor).isActive = true
        guideLine.widthAnchor.constraint(equalTo: safeLayout.widthAnchor, multiplier: 0.8).isActive = true
        guideLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        guideLine.centerXAnchor.constraint(equalTo: safeLayout.centerXAnchor).isActive = true
        
        presentCostText.centerXAnchor.constraint(equalTo: presentCostView.centerXAnchor).isActive = true
        textAutolayout = presentCostText.topAnchor.constraint(equalTo: guideLine.bottomAnchor)
        textAutolayout.isActive = true
        
        scrollView.topAnchor.constraint(equalTo: guideLine.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor).isActive = true
    }
    
    private func animation() {
        UIView.animate(withDuration: 0) {
            self.presentCostText.alpha = 0.0
            self.textAutolayout.constant = CGFloat(0)
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 1) {
            self.presentCostText.alpha = 1.0
            self.textAutolayout.constant = CGFloat(-60)
            self.view.layoutIfNeeded()
        }
    }
    
    private func makeCostByTag(data: [String:Int]) {
        let dataSorted = tagData.sorted { $0.1 > $1.1 }
        var itemIndex = 0
        for (tag, price) in dataSorted {
            let titleTag = UILabel()
            titleTag.text = tag
            let titlePrice = UILabel()
            titlePrice.text = "\(price)"
            
            let circle = UIView()
            circle.backgroundColor = MyColors.yellow
            scrollView.addSubview(circle)
            circle.addSubview(titleTag)
            circle.addSubview(titlePrice)
            
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            
            titleTag.translatesAutoresizingMaskIntoConstraints = false
            titleTag.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
            titleTag.bottomAnchor.constraint(equalTo: circle.centerYAnchor, constant: -10).isActive = true
            
            titlePrice.translatesAutoresizingMaskIntoConstraints = false
            titlePrice.centerXAnchor.constraint(equalTo: circle.centerXAnchor).isActive = true
            titlePrice.topAnchor.constraint(equalTo: circle.centerYAnchor, constant: 10).isActive = true
            
            if itemViewArr.isEmpty {
                circle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
                circle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7).isActive = true
                circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
            } else {
                circle.topAnchor.constraint(equalTo: itemViewArr[itemIndex].bottomAnchor, constant: 10).isActive = true
                circle.widthAnchor.constraint(equalTo: itemViewArr[itemIndex].widthAnchor, multiplier: 0.7).isActive = true
                circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
                itemIndex += 1
            }
            
            itemViewArr.append(circle)
            
        }
        scrollView.bottomAnchor.constraint(equalTo: itemViewArr[itemViewArr.count-1].bottomAnchor, constant: 20).isActive = true
    }
}

