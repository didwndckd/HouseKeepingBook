//
//  CustomCalendar.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/17.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol CustomCalendarDelegate: class {
    func presentMonthCostView(date: Date)
}

class CustomCalendar: UIView {
    
    private var selectDay = false
    
    private let calendar = JTACMonthView()
    private let calendarData = Calendar(identifier: .gregorian)
    weak var delegate: CustomCalendarDelegate?
    
    var year = 0
    var month: Int = 0
    
    
    
    init(calenderMonth: Int, calendarYear: Int) {
        super.init(frame: .zero)
        year = calendarYear
        month = calenderMonth
        
        calendar.calendarDataSource = self
        calendar.calendarDelegate = self
        calendar.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calendar.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeader.identifier)
        calendar.backgroundColor = .white
        setupUI()
        
    }
    
    func reloadCalender() {
        calendar.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubview(calendar)
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        calendar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        calendar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        calendar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
    }
    
    
    
}

extension CustomCalendar: JTACMonthViewDataSource{
    
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let startDateComponents = DateComponents(calendar: calendarData, year: year, month: month, day: 1)
        guard let startDate = startDateComponents.date else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM dd"
            let startDate = formatter.date(from: "2020 01 01")!
            let endDate = Date()
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate)
        }
        guard let lastDay = DataPicker.shared.howManyDaysInMonth(date: startDate) else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM dd"
            let startDate = formatter.date(from: "2020 01 01")!
            let endDate = Date()
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let endDate = formatter.date(from: "\(year) \(month) \(lastDay)")!
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate)
        
    }
    
    
}

extension CustomCalendar: JTACMonthViewDelegate {
    
    //
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()
        formatter.dateFormat = "y.MMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(
            withReuseIdentifier: DateHeader.identifier,
            for: indexPath) as! DateHeader
        header.dateHeader.text = formatter.string(from: range.start)
        header.dateHeader.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        
        return header
    }
    //
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
//        print("makecell")
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
            cell.dateLabel.textColor = MyColors.red
            cell.todayLabel.isHidden = false
        }else {
            
            cell.todayLabel.isHidden = true
        }
        
        
        
       }
    private func handleCellSelected(cell: DateCell, cellState: CellState) {
        
        if cellState.isSelected {
            cell.selectedView.isHidden = false
            guard selectDay else { return selectDay = true }
            delegate?.presentMonthCostView(date: cellState.date)
            
            
        }else {
            cell.selectedView.isHidden = true
            selectDay = false
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
