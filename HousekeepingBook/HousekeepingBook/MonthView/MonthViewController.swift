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
    
    private let budgetView = UIView()
    private let budgetButton = UIButton(type: .system)
    
    private let calender = JTACMonthView()
    private var date = Date()
    private let calendarData = Calendar(identifier: .gregorian)
    
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
        calender.backgroundColor = .systemBackground
        calender.calendarDataSource = self
        calender.calendarDelegate = self
        calender.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calender.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeader.identifier)
        
        budgetButton.addTarget(self, action: #selector(didTapBudgetButton), for: .touchUpInside)
        
        budget = DataPicker.shared.getMonthBudget(month: date)
        
        setupUI()
        
        setThisMonth()
        
        getDateBudget()
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
        
        view.addSubview(calender)
        view.addSubview(budgetView)
        budgetView.addSubview(budgetButton)
        
        let guide = view.safeAreaLayoutGuide
        
        calender.translatesAutoresizingMaskIntoConstraints = false
        budgetView.translatesAutoresizingMaskIntoConstraints = false
        budgetButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        calender.topAnchor.constraint(equalTo: budgetView.bottomAnchor).isActive = true
        calender.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        calender.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        calender.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
}

extension MonthViewController: JTACMonthViewDataSource{
    
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2020 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate)
    }
    
    
}

extension MonthViewController: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()
        formatter.dateFormat = "y.MMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: DateHeader.identifier, for: indexPath) as! DateHeader
        header.dateHeader.text = formatter.string(from: range.start)
        header.dateHeader.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
   
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        configurationCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell else { return }
        configurationCell(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell else { return }
        configurationCell(view: cell, cellState: cellState)
    }
    
    
    private func configurationCell(view: JTACDayCell, cellState: CellState) {
           guard let cell = view as? DateCell else { return }
           cell.dateLabel.text = cellState.text
        
           handleCell(cell: cell, cellState: cellState)
           handleCellSelected(cell: cell, cellState: cellState)
       }

       private func handleCell(cell: DateCell, cellState: CellState) {
        
           if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
           }else {
               cell.isHidden = true
           }
            
        if cellState.day == .sunday {
            cell.dateLabel.textColor = .red
        }else if cellState.day == .saturday {
            cell.dateLabel.textColor = .blue
        }else {
            cell.dateLabel.textColor = .black
        }
        
        let currentTime = setCurrentTimeZone(state: Date())
        let cellTime = setCurrentTimeZone(state: cellState.date)
        //print("current: \(currentTime) | cellTime \(cellTime)")
        if currentTime == cellTime {
            cell.selectedView.isHidden = false
        }else {
            cell.selectedView.isHidden = true
        }
        
        
        
       }
    private func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            
        }else {
            
        }
    }
    
    private func setCurrentTimeZone(state: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: state)
        return date
    }
    
}


extension MonthViewController: BudgitViewControllerDelegate {
    func setBudget() {
        budget = DataPicker.shared.getMonthBudget(month: date)
    }
    
    
}
