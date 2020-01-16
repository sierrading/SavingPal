//
//  ProjectModal.swift
//  Jan08SavingPal
//
//  Created by dingding on 2020/1/10.
//  Copyright © 2020 dingding. All rights reserved.
//

import Foundation

struct SaveMoneyReturnData: Codable {
    var data: String
    var errorCode: Int

}

struct ProjectData: Codable {
    var data: [ProjectModal]
}


struct HistoryMoney: Codable {
    var historyDate: String
    var money: Int
}

struct History: Codable {
    var history: [HistoryMoney]
    var totalMoney: Int
}

struct HistoryData: Codable {
    var data: History
}

struct ProjectModal: Codable {
    var projectName: String//專案名稱
    var projectTarget: Double//專案目標
    var projectFreq: String//數字
    var projectStart: Date //專案開始日
    var projectEnd: Date //專案結束日
    var projectNumber: Int? //專案人數
    //var saveMoney: Double?
    var projectId: Int
    var projectPhoto: String?
    var status: Int

    
    
    
    
    static func calculateFrequncyDay(frequencyText: String, saveDay: Double) -> Double {
           var frequcyDay: Double
           if frequencyText == "每天" {
               frequcyDay = saveDay
           } else if frequencyText == "每週" {
               
               frequcyDay = saveDay / 7
               frequcyDay.round(.down)
           } else {
               frequcyDay = saveDay / 30
               frequcyDay.round(.down)
           }
           return frequcyDay
    }
       
    
    func frequencySaveMoney() -> Int {
        
        let saveDay: Double
        let days = projectStart.daysBetweenDate(toDate: projectEnd)
        saveDay = Double(days)
        let frequencyDay = ProjectModal.calculateFrequncyDay(frequencyText: projectFreq, saveDay: saveDay)
        var count = projectNumber ?? 1
        
        
        
        var saveMoney: Double = 0
        let money = Int((projectTarget - saveMoney) / Double(count) / frequencyDay )
        return money
    }
    
    static func saveToFile(projects: [ProjectModal]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(projects) {
             let userDefault = UserDefaults.standard
             userDefault.set(data, forKey: "projects")

        }
    }
    
    static func readProjectsFromFile() -> [ProjectModal]? {
        let userDefaults = UserDefaults.standard
        let propertyDecoder = PropertyListDecoder()
        if let data = userDefaults.data(forKey: "projects"), let projects = try? propertyDecoder.decode([ProjectModal].self, from: data) {
            return projects
        } else {
            return nil
        }
    }
}
