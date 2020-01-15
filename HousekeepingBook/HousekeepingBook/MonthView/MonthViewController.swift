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
    
    

    private let calender = JTACMonthView()
    private let budgetButton = UIButton(type: .system)
    private var monthData = DataPicker.shared.getMonthData(date: Date())
    private var date = Date()
    
    
    var budget: Int? {
        didSet {
            guard let afterBindingBuget = budget else {
                budgetButton.setTitle("예산을 등록하세요.", for: .normal)
                return
                
            }
            guard let budgetButtonTitleText = DataPicker.shared.moneyForamt(price: afterBindingBuget) else { return }
            budgetButton.setTitle("\(budgetButtonTitleText) 원", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        calender.backgroundColor = .systemBackground
        calender.calendarDataSource = self
        calender.calendarDelegate = self
        calender.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calender.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeader.identifier)
        
        budgetButton.addTarget(self, action: #selector(didTapBudgetButton), for: .touchUpInside)
        
        budget = DataPicker.shared.getMonthBudget(month: date)
        
        setupUI()
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
    

    private func setupUI() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(calender)
        view.addSubview(budgetButton)
        
        budgetButton.translatesAutoresizingMaskIntoConstraints = false
        calender.translatesAutoresizingMaskIntoConstraints = false
        
        
        budgetButton.titleLabel?.font = .systemFont(ofSize: 40, weight: .heavy)
        budgetButton.tintColor = .black
        budgetButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        
        budgetButton.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        budgetButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        budgetButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        budgetButton.heightAnchor.constraint(equalToConstant: view.bounds.height / 4).isActive = true
        
        calender.topAnchor.constraint(equalTo: budgetButton.bottomAnchor).isActive = true
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
