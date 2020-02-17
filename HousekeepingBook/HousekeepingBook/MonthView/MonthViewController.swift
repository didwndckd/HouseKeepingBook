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
    
    var timer = Timer()
    
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
        print("MonthViewcontroller viewWillAppear")
        
        let currentMonthComponent = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
        guard let currentDate = currentMonthComponent.date else {return}
        setBudget(date: currentDate)
        calenders[1].reloadCalender()
        
        
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
        
        print(year, month)
    }
    
    
    
    private func setBudget(date: Date) {
        
        
        guard var thisMonthBudget = DataPicker.shared.getMonthBudget(month: date) else {
            budget = nil
            return
        }
        let count = DataPicker.shared.howManyDaysInMonth(date: date) ?? 0
        
        for day in 1...count {
            let yearStr = DataPicker.shared.setFormatter(date: date, format: "yyyy")
            let monthStr = DataPicker.shared.setFormatter(date: date, format: "MM")
//            let formatter = DateFormatter()
            
            guard let year = Int(yearStr), let month = Int(monthStr)  else {
                return
            }
            let components = DateComponents(calendar: calendarData, year: year, month: month, day: day)
            guard let key = components.date else { return print("키 변환 실패")}
            
            
            
            let datas = DataPicker.shared.getData(date: key)
            
            for data in datas {
                thisMonthBudget -= data.price
//                print("성공쓰")
            }
            
        }
        
        budget = thisMonthBudget
        
    }
    
    
    @objc private func didTapBudgetButton() {
        // 예산 버튼 클릭
        print("didTapBudgetButton()")
        let budgetViewController = BudgetViewController()
        budgetViewController.delegate = self
        budgetViewController.budget = budget
        let confonents = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
        guard let date = confonents.date else { return }
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
    
    var calenders: [CustomCalendar] = []
    
    private func setupCalenders() {
        
        
        
        for i in 0...2 {
            
            let tempYear = months[i].year
            let tempMonth = months[i].month
            
            let customCalendar = CustomCalendar(calenderMonth: tempMonth, calendarYear: tempYear)
            scrollView.addSubview(customCalendar)
            customCalendar.translatesAutoresizingMaskIntoConstraints = false
            customCalendar.delegate = self
            
            
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
    
    func setCalendarMonthData(year: Int, month: Int) -> Date?{
        let dateComponents = DateComponents(
            calendar: calendarData,
            year: year,
            month: month,
            day: 1)
        
        let date = dateComponents.date
        return date
        
    }
    
    func setCalendars (year: Int, month: Int, calendar: CustomCalendar) {
        var year = year
        var month = month
        
        if month > 12 {
            month = 1
            year += 1
        }else if month < 1 {
            month = 12
            year -= 1
        }
        
        calendar.year = year
        calendar.month = month
        calendar.reloadCalender()
    }
    
    
    
    
}

extension MonthViewController: CustomCalendarDelegate {
    func presentMonthCostView(date: Date) {
        let monthCostViewController = MonthCostViewController()
        monthCostViewController.date = date
        monthCostViewController.delegate = self
        present(monthCostViewController, animated: true)
        
    }
    
    
    
}

extension MonthViewController: MonthCostViewControllerDelegate {
    func reLoadCalendar() {
        setBudget(date: date)
        calenders[1].reloadCalender()
    }
    
    
}





extension MonthViewController: UIScrollViewDelegate {
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        
       
        
        
        if index == 0 {
            print("-")
            month -= 1
            print(year, month)
            
            let comfonents = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
            if let date = comfonents.date {
                setBudget(date: date)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                scrollView.contentOffset.x = scrollView.bounds.width
                self.setCalendars(year: self.year, month: self.month - 1, calendar: self.calenders[0])
            }
            setCalendars(year: year, month: month, calendar: calenders[1])
            setCalendars(year: year, month: month + 1, calendar: calenders[2])
            
            
        }
        else if index == 2 {
            print("+")
            month += 1
            print(year, month)
            
            let comfonents = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
            if let date = comfonents.date {
                setBudget(date: date)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                scrollView.contentOffset.x = scrollView.bounds.width
                self.setCalendars(year: self.year, month: self.month + 1, calendar: self.calenders[2])
            }
            setCalendars(year: year, month: month, calendar: calenders[1])
            setCalendars(year: year, month: month - 1, calendar: calenders[0])
            
        }
        
        
    }
}

extension MonthViewController: BudgitViewControllerDelegate {
    func setBudget(budget: Int) {
        self.budget = budget
    }
    
    
}
