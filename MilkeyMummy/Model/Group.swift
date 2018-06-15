//
//  Group.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/12.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Salada

class Group: Object {
    @objc dynamic var name: String?
    @objc dynamic var users: Set<String> = []
}
