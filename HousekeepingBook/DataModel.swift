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

    let monthFormat = "yyyyMM"
    let dateFormat = "dd"
    let dateTitleFormat = "yyyy MM dd"
    
    
    // date format 세팅 메서드
    private func setFormatter(date: Date, format: String)-> String {
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
    
    
    func getMonthBudget (month: Date) -> Int{
        let key = "budget" + setFormatter(date: month, format: monthFormat)
        let budget = UserDefaults.standard.integer(forKey: key)
        return budget
    }
    
    func setMonthBuget (month: Date, budget: Int) {
        let key = "budget" + setFormatter(date: month, format: monthFormat)
        UserDefaults.standard.set(budget, forKey: key)
    }
    
    func getMonthData(date: Date)-> [String: [String: [CostModel] ] ]? {
        
        let key = setFormatter(date: date, format: monthFormat)
        
        guard let monthData = UserDefaults.standard.object(forKey: key) as? [String: [String: [CostModel]]] else {
            return nil
        }
        return monthData
        
    }
    
    func getDateData(date: Date, monthData: [String: [CostModel]]) -> [CostModel]? {
        
        let dateKey = setFormatter(date: date, format: dateFormat)
        
        guard let dateData = monthData[dateKey] else {return nil}
        
        return dateData
        
    }
    
}
