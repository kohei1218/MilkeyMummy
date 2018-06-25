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

class TimeLineDetailViewController: UIViewController {

    var opponentUser:FirebaseApp.User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("nickname!!!:", self.opponentUser?.nickName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
