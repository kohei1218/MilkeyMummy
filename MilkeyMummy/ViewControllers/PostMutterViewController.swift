//
//  PostMutterViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/19.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import TextFieldEffects
import Salada
import Firebase
import IBAnimatable

class PostMutterViewController: UIViewController {
    
    @IBOutlet weak var postMutterTextView: MadokaTextField!
    @IBOutlet weak var postMutterButton: AnimatableButton!
    private var currentUser: FirebaseApp.User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.User.current{ user in
            self.currentUser = user
        }
        postMutterTextView.borderColor = UIColor.appColor()
        postMutterTextView.placeholderColor = UIColor.lightGray
        postMutterTextView.placeholderFontScale = 1
        postMutterButton.isEnabled = false
        postMutterButton.backgroundColor = UIColor(code: "#BBDEFB")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCloseView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionPostMutter(_ sender: Any) {
        currentUser?.mutter = postMutterTextView.text
        currentUser?.mutterDate = Date()
        dismiss(animated: true, completion: nil)
    }

}

extension PostMutterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let input: NSMutableString = textField.text!.mutableCopy() as! NSMutableString
        input.replaceCharacters(in: range, with: string)
        let inputStr: String = String(input)
        if (inputStr.isEmpty) {
            postMutterButton.isEnabled = false
            postMutterButton.backgroundColor = UIColor(code: "#BBDEFB")
        } else {
            postMutterButton.isEnabled = true
            postMutterButton.backgroundColor = UIColor.appColor()
        }
        return true
    }
    
    func setButtonState(isEnabled: Bool) {
        postMutterButton.isEnabled = isEnabled
        postMutterButton.backgroundColor = isEnabled ? UIColor.appColor() : UIColor(code: "#BBDEFB")
    }
}
