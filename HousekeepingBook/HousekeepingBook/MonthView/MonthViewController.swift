//
//  MonthViewController.swift
//  HousekeepingBook
//
//  Created by 박지승 on 2020/01/13.
//  Copyright © 2020 Jisng. All rights reserved.
//
import JTAppleCalendar
import UIKit

// tab-bar-tag-1: 월별, 캘린더 컨트롤러

class MonthViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let budgetView = UIView()
    private let budgetButton = UIButton(type: .system)
    
    private var date = Date()
    private let calendarData = Calendar(identifier: .gregorian)
    private var months: [(year: Int, month: Int)] = DataPicker.shared.monthInit(date: Date())
    

    private var year = 0
    private var _month: Int = 0
    private var month: Int {
        get {
            return _month
        }
        set {
            if newValue > 12 {
                _month = 1
                year += 1
            }else if newValue < 1 {
                _month = 12
                year -= 1
            }else {
                _month = newValue
            }
        }
    }
    
    var dayBudget = 0
    var budget: Int? {
        didSet {
            guard let afterBindingBuget = budget else {
                budgetButton.setTitle("예산을 등록하세요.", for: .normal)
                return
            }
            guard let budgetButtonTitleText = DataPicker.shared.moneyForamt(price: afterBindingBuget)
                else { return }
            
            budgetButton.setTitle("\(budgetButtonTitleText) 원", for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = MyColors.lightgray
        
        budgetButton.addTarget(self, action: #selector(didTapBudgetButton), for: .touchUpInside)
        
        budget = DataPicker.shared.getMonthBudget(month: date)
        
        setupUI()
        
        setThisMonth()
        
        getDateBudget()
        
        setupCalenders()
        
        scrollView.delegate = self
    }
    
    
    @objc private func didTapBudgetButton() {
        // 예산 버튼 클릭
        print("didTapBudgetButton()")
        let budgetViewController = BudgetViewController()
        budgetViewController.delegate = self
        let budget = DataPicker.shared.getMonthBudget(month: date)
        budgetViewController.budget = budget
        budgetViewController.date = date
        present(budgetViewController, animated: true)
    }
    
    private func getDateBudget() {
        let start = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
        month += 1
        let end = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
        month -= 1
        let numberOfDays = calendarData.dateComponents([.day], from: start, to: end)
        
        guard let monthBudget = budget else { return }
        guard let days = numberOfDays.day else { return }
        dayBudget = monthBudget / days
    }
    
    private func setThisMonth() {
        let today = Date()
        
        let yearToString = DataPicker.shared.setFormatter(date: today, format: "yyyy")
        let monthToString = DataPicker.shared.setFormatter(date: today, format: "MM")
        
        print(monthToString)
        guard let yearToInt = Int(yearToString) else { return }
        year = yearToInt
        guard let monthToInt = Int(monthToString) else { return }
        month = monthToInt
    }
    

    private func setupUI() {
        
        view.addSubview(scrollView)
        view.addSubview(budgetView)
        budgetView.addSubview(budgetButton)
        
        let guide = view.safeAreaLayoutGuide
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        budgetView.translatesAutoresizingMaskIntoConstraints = false
        budgetButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isPagingEnabled = true
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        budgetView.backgroundColor = MyColors.yellow
    
        budgetButton.titleLabel?.font = .systemFont(ofSize: 40, weight: .heavy)
        budgetButton.tintColor = MyColors.yellow
        budgetButton.backgroundColor = .white
        
        budgetView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        budgetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        budgetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        budgetView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.4).isActive = true
        
        budgetButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10).isActive = true
        budgetButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10).isActive = true
        budgetButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10).isActive = true
        budgetButton.bottomAnchor.constraint(equalTo: budgetView.bottomAnchor, constant: -10).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: budgetView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentOffset.x = scrollView.bounds.width
    }
    
    
    private func setupCalenders() {
        
        var calenders: [CustomCalendar] = []
        
        for i in 0...2 {
            
            let tempYear = months[i].year
            let tempMonth = months[i].month
            
            let customCalendar = CustomCalendar(calenderMonth: tempMonth, calendarYear: tempYear)
            scrollView.addSubview(customCalendar)
            customCalendar.translatesAutoresizingMaskIntoConstraints = false
            
            let leading = i == 0 ? scrollView.leadingAnchor : calenders[i - 1].trailingAnchor
            
            customCalendar.leadingAnchor.constraint(equalTo: leading).isActive = true
            customCalendar.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            customCalendar.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            customCalendar.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            customCalendar.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            if i == 2 {
                customCalendar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            }
            calenders.append(customCalendar)
        }
    }
    
    
}

extension MonthViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        print(index)
    }
}

extension MonthViewController: BudgitViewControllerDelegate {
    func setBudget() {
        budget = DataPicker.shared.getMonthBudget(month: date)
    }
    
    
}
