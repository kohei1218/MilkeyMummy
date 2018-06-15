//
//  RegistInfoViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/13.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import Salada
import SVProgressHUD
import IBAnimatable

class RegistInfoViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: KaedeTextField!
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var birthDateTextField: KaedeTextField!
    @IBOutlet weak var locateTextField: KaedeTextField!
    @IBOutlet weak var positionTextField: KaedeTextField!
    @IBOutlet weak var incomeTextField: KaedeTextField!
    @IBOutlet weak var startButton: AnimatableButton!
    
    private let prefecturePickerView = UIPickerView()
    private let prefectures = Const.kPrefectures
    private var user: FirebaseApp.User = FirebaseApp.User()
    private var firebaseUser: FirebaseApp.User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        self.view.backgroundColor = UIColor.appColor()
        prefecturePickerView.dataSource = self
        prefecturePickerView.delegate = self
        startButton.isEnabled = false
        
        self.setTextField()
        FirebaseApp.User.current{ user in
            SVProgressHUD.dismiss()
            self.firebaseUser = user
            self.emailTextField.text = self.firebaseUser?.email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextField() {
        nickNameTextField.backgroundColor = UIColor(code: "#42A5F5")
        nickNameTextField.foregroundColor = UIColor.appColor()
        nickNameTextField.placeholderColor = UIColor.white
        nickNameTextField.placeholderFontScale = 1
        
        emailTextField.backgroundColor =  UIColor(code: "#42A5F5")
        emailTextField.foregroundColor = UIColor.appColor()
        emailTextField.placeholderColor = UIColor.white
        emailTextField.placeholderFontScale = 1
        
        birthDateTextField.backgroundColor =  UIColor(code: "#42A5F5")
        birthDateTextField.foregroundColor = UIColor.appColor()
        birthDateTextField.placeholderColor = UIColor.white
        birthDateTextField.placeholderFontScale = 1
        
        locateTextField.backgroundColor =  UIColor(code: "#42A5F5")
        locateTextField.foregroundColor = UIColor.appColor()
        locateTextField.placeholderColor = UIColor.white
        locateTextField.placeholderFontScale = 1
        
        positionTextField.backgroundColor =  UIColor(code: "#42A5F5")
        positionTextField.foregroundColor = UIColor.appColor()
        positionTextField.placeholderColor = UIColor.white
        positionTextField.placeholderFontScale = 1
        
        incomeTextField.backgroundColor =  UIColor(code: "#42A5F5")
        incomeTextField.foregroundColor = UIColor.appColor()
        incomeTextField.placeholderColor = UIColor.white
        incomeTextField.placeholderFontScale = 1
    }

    @IBAction func actionTouchBirthDateField(_ sender: Any) {
        birthDateTextField.text = getFormattedDateStr(date: Date())
        user.birth = Date()
        let datePicker = UIDatePicker()
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChange(sender:)), for: UIControlEvents.valueChanged)
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Calendar.current.startOfDay(for: Date()))
        
        birthDateTextField.inputView = datePicker
        validationUser()
    }
    
    
    @IBAction func actionTouchLocateField(_ sender: Any) {
        locateTextField.text = "東京都"
        locateTextField.inputView = prefecturePickerView
        validationUser()
    }
    
    @objc func datePickerValueChange(sender:UIDatePicker) {
        user.birth = sender.date
        birthDateTextField.text = getFormattedDateStr(date: sender.date)
    }
    
    private func getFormattedDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd";
        return dateFormatter.string(from: date)
        
    }
    
    func validationUser() {
        if user.nickName == nil || (user.nickName?.isEmpty)! {
            setButtonState(bool: false)
            return
        }
        if user.email == nil || (user.email?.isEmpty)! {
            setButtonState(bool: false)
            return
        }
        if user.birth == nil {
            setButtonState(bool: false)
            return
        }
        if user.position == nil || (user.position?.isEmpty)! {
            setButtonState(bool: false)
            return
        }
        if user.income == 0 {
            setButtonState(bool: false)
            return
        }
        setButtonState(bool: true)
    }
    
    func setButtonState(bool: Bool) {
        startButton.isEnabled = bool
        if bool == true {
            startButton.setTitleColor(UIColor.appColor(), for: .normal)
        } else {
            startButton.setTitleColor(UIColor(code: "#BBDEFB"), for: .normal)
        }
    }

}

extension RegistInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.prefectures.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.prefectures[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.locateTextField.text = self.prefectures[row]
    }
    
}

extension RegistInfoViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case nickNameTextField:
            user.nickName = nickNameTextField.text
            validationUser()
            break
        case emailTextField:
            user.email = emailTextField.text
            validationUser()
            break
        case positionTextField:
            user.position = positionTextField.text
            validationUser()
            break
        case incomeTextField:
            if !(incomeTextField.text?.isEmpty)! {
                user.income = Int(incomeTextField.text!)!
                validationUser()
            } else {
                user.income = 0
                validationUser()
            }
            break
        default:
            break
        }
        return true
    }
}
