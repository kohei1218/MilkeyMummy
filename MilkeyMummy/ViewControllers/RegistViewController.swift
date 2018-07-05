//
//  RegistViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/11.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import Salada
import AlamofireImage
import Alamofire

class RegistViewController: UIViewController {
    
    @IBOutlet weak var feMaleLoginButton: FBSDKLoginButton!
    var isMale: Bool = true
    var ref: DatabaseReference = Database.database().reference()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feMaleLoginButton.readPermissions = ["public_profile", "email"]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.user = user
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionRegistFemale(_ sender: Any) {
        isMale = false
    }
    
    @IBAction func actionRegistMale(_ sender: Any) {
        isMale = true
    }
    
}

extension RegistViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        //firebaseにログイン
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("error", error.localizedDescription)
                return
            }
            self.user = user
            self.getFacebookUserInfo()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    //facebookのuser情報取得
    func getFacebookUserInfo() {
        FBSDKGraphRequest(graphPath: "me",
                          parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email , gender"]).start(
                            completionHandler: { (connection, result_, error) -> Void in
                                if (error == nil) {
                                    let dictionary = result_ as! NSDictionary
                                    self.saveUserData(dictionary: dictionary)
                                }})
    }
    
    //firebaseにuser情報保存
    func saveUserData(dictionary: NSDictionary) {
        let group: Group = Group(id: self.isMale ? "males" : "females")!
        group.name = isMale ? "males" : "females"
        group.save { (ref, error) in
            do {
                let user: FirebaseApp.User = FirebaseApp.User(id: (self.user?.uid)!)!
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.gender = self.isMale ? "male" : "female"
                user.groups.insert((ref?.key)!)
                if let urlStr: String = dictionary.value(forKeyPath: "picture.data.url") as? String {
                    Alamofire.request(urlStr).responseData { response in
                        if let response = response.result.value {
                            user.thumbnail = File(data: response, mimeType: .jpeg)
                            user.save()
                            user.save({ (ref, error) in
                                group.users.insert((ref?.key)!)
                            })
                        } else {
                            user.save()
                            user.save({ (ref, error) in
                                group.users.insert((ref?.key)!)
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    
}


