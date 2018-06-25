//
//  TimeLIneViewCell.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/15.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Salada
import Firebase

class TimeLIneCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var mutterLabel: UILabel!
    
    var disposer: Disposer<FirebaseApp.User>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
