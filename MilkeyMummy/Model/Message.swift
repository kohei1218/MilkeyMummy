//
//  Message.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/07/05.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Salada

class Message: Object {
    @objc dynamic var senderId: String?
    @objc dynamic var text: String?
    @objc dynamic var postDate: Date?
}
