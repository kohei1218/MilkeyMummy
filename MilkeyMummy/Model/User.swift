//
//  User.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/12.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Salada
import Firebase

extension FirebaseApp {
    class User: Object {
        @objc dynamic var name: String?
        @objc dynamic var email: String?
        @objc dynamic var nickName: String?
        @objc dynamic var age: Int = 0
        @objc dynamic var gender: String?
        @objc dynamic var groups: Set<String> = []
        @objc dynamic var url: String?
        @objc dynamic var birth: Date?
        @objc dynamic var thumbnail: File?
        @objc dynamic var income: Int = 0
        @objc dynamic var position: String?
        @objc dynamic var residence: String?
        @objc dynamic var seeDesire: String?
        @objc dynamic var liquor: String?
        @objc dynamic var cigarette: String?
        @objc dynamic var mutter: String?
        @objc dynamic var profile: String?
        @objc dynamic var mutterDate: Date?
        @objc dynamic var height: Int = 0
        @objc dynamic var figure: String?
        @objc dynamic var future: String?
        @objc dynamic var hopePlace: String?
        @objc dynamic var hobby: String?
        @objc dynamic var type: String?
        @objc dynamic var holiday: String?
    }
}

extension FirebaseApp.User {
    
    static func current(_ completionHandler: @escaping ((FirebaseApp.User?) -> Void)) {
        guard let user: User = Auth.auth().currentUser else {
            completionHandler(nil)
            return
        }
        FirebaseApp.User.observeSingle(user.uid, eventType: .value, block: { (user) in
            guard let user: FirebaseApp.User = user else {
                _ = try? Auth.auth().signOut()
                completionHandler(nil)
                return
            }
            
            completionHandler(user)
        })
    }
    
}

//class DataClass: Codable {
//    let name, gender, url, work, position, residence, seeDesire, liquor, cigarette: String
//    let age, lowIncome, highIncome: Int
//    let groups: Set<String>
//    let birth: Date
//    let thumbnail: File
//
//    init(name: String, gender: String, url: String, work: String, position: String, residence: String, seeDesire: String, liquor: String, cigarette: String) {
//        self.sell = sell
//        self.buy = buy
//        self.high = high
//        self.low = low
//        self.last = last
//        self.vol = vol
//        self.timestamp = timestamp
//    }
//}

