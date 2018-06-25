//
//  TimeLineDetailViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/25.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Salada
import Firebase
import FirebaseStorageUI

class TimeLineDetailViewController: UIViewController {

    var opponentUser:FirebaseApp.User?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var residentLabel: UILabel!
    @IBOutlet weak var mutterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        self.navigationItem.title = opponentUser?.nickName
        nickNameLabel.text = opponentUser?.nickName
        ageLabel.text = (opponentUser?.age.description)! + "歳"
        residentLabel.text = opponentUser?.residence
        mutterLabel.text = opponentUser?.mutter
        if let ref: StorageReference = opponentUser?.thumbnail?.ref {
            self.profileImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "loading-appcolor"))
        }
    }

}
