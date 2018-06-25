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
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var figureLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var futureLabel: UILabel!
    @IBOutlet weak var seeDesireLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var liquorLabel: UILabel!
    @IBOutlet weak var cigaretteLabel: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    
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
        setUserProfile()
        if let ref: StorageReference = opponentUser?.thumbnail?.ref {
            self.profileImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "loading-appcolor"))
        }
    }
    
    private func setUserProfile() {
        nickNameLabel.text = opponentUser?.nickName
        ageLabel.text = (opponentUser?.age.description)! + "歳"
        residentLabel.text = opponentUser?.residence
        mutterLabel.text = opponentUser?.mutter
        profileLabel.text = opponentUser?.profile
        heightLabel.text = opponentUser?.height.description
        figureLabel.text = opponentUser?.figure
        futureLabel.text = opponentUser?.future
        seeDesireLabel.text = opponentUser?.seeDesire
        placeLabel.text = opponentUser?.hopePlace
        hobbyLabel.text = opponentUser?.hobby
        typeLabel.text = opponentUser?.type
        liquorLabel.text = opponentUser?.liquor
        cigaretteLabel.text = opponentUser?.cigarette
        holidayLabel.text = opponentUser?.holiday
        positionLabel.text = opponentUser?.position
    }

}
