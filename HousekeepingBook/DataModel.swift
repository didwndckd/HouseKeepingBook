//
//  DataModel.swift
//  HousekeepingBook
//
//  Created by 양중창 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation



class DataPicker {
    static let shared = DataPicker()
    static var todayBudget: Int?
    
    let monthFormat = "yyyyMM"
    let dateFormat = "yyyyMMdd"
    let dateTitleFormat = "yyyy MM dd"
    
    
    // date format 세팅 메서드
    func setFormatter(date: Date, format: String)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        let returnFormat = formatter.string(from: date)
        return returnFormat
    }
    
    func moneyForamt(price: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let numberFormat = formatter.string(from: price as NSNumber)
        
        return numberFormat
    }
    

    func getDateTitleForamt(date: Date) -> String {
        
        let stringDate = setFormatter(date: date, format: dateTitleFormat)
        return stringDate
    }
    
    
    func getMonthBudget (month: Date) -> Int {
        let key = "budget" + setFormatter(date: month, format: monthFormat)
        let budget = UserDefaults.standard.integer(forKey: key)
        return budget
    }
    
    func setMonthBuget (month: Date, budget: Int) {
        let key = "budget" + setFormatter(date: month, format: monthFormat)
        
        UserDefaults.standard.set(budget, forKey: key)
    }

    
    func getData(date: Date) -> [CostModel] {
        let key = "date" + setFormatter(date: date, format: dateFormat)
        var tempArray: [CostModel] = []
        
        let decoder = JSONDecoder()
        
        let userDefaults = UserDefaults.standard
        let loadData = userDefaults.object(forKey: key)
        guard let successLoadData = loadData as? [String] else {return []}
        for jsonString in successLoadData {
            let optionalData = jsonString.data(using: .utf8)
            if let data = optionalData, let costModel = try? decoder.decode(CostModel.self, from: data) {
                tempArray.append(costModel)
            }
        }
        
        return tempArray
    }
    
    func setData(date: Date, datas: [CostModel]) {
        let key = "date" + setFormatter(date: date, format: dateFormat)
        var tempArray: [String] = []
        let encoder = JSONEncoder()
        
        for data in datas {
            
            let jsonData = try? encoder.encode(data)
            guard let data = jsonData, let jsonString = String(data: data, encoding: .utf8)
                else { return }
            tempArray.append(jsonString)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(tempArray, forKey: key)
        
    }
    
    func howManyDaysInMonth(date: Date) -> Int? {
        var year: Int
        var month: Int
        let calendar = Calendar(identifier: .gregorian)
        let yearToString = setFormatter(date: date, format: "yyyy")
        let monthToString = setFormatter(date: date, format: "MM")
        
        guard let yearToInt = Int(yearToString) else { return nil }
        year = yearToInt
        guard let monthToInt = Int(monthToString) else { return nil}
        if monthToInt > 12 {
            month = 1
            year += 1
        }else if monthToInt < 1 {
            month = 12
            year += 1
        }else {
            month = monthToInt
        }
        
        let start = DateComponents(calendar: calendar, year: year, month: month, day: 1)
        month += 1
        let end = DateComponents(calendar: calendar, year: year, month: month, day: 1)
        let numberOfDays = calendar.dateComponents([.day], from: start, to: end)
        
        guard let days = numberOfDays.day else { return nil}
        
        return days
        
    }
    
    
    
}
