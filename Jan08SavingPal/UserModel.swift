//
//  UserModel.swift
//  SavingPalJan01
//
//  Created by 丁丁丁 on 2020/1/1.
//  Copyright © 2020 ding. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    var name:String?
    var email:String?
    var userId:String?
    var imageUrl:URL?
    var token: String?
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "user")
                                    
        }
    }
    
    static var me: UserModel? {
        if let data = UserDefaults.standard.data(forKey: "user"), let userModel = try? JSONDecoder().decode(UserModel.self, from: data) {
            return userModel
        } else {
            return nil
        }
    }
}
