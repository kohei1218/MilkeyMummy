//
//  RegistInfoViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/13.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import TextFieldEffects

class RegistInfoViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var nickNameTextField: KaedeTextField!
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var confirmPasswordTextField: KaedeTextField!
    @IBOutlet weak var birthDateTextField: KaedeTextField!
    @IBOutlet weak var locateTextField: KaedeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.appColor()
        self.setTextField()
        // Do any additional setup after loading the view.
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
        passwordTextField.backgroundColor =  UIColor(code: "#42A5F5")
        passwordTextField.foregroundColor = UIColor.appColor()
        passwordTextField.placeholderColor = UIColor.white
        passwordTextField.placeholderFontScale = 1
        confirmPasswordTextField.backgroundColor =  UIColor(code: "#42A5F5")
        confirmPasswordTextField.foregroundColor = UIColor.appColor()
        confirmPasswordTextField.placeholderColor = UIColor.white
        confirmPasswordTextField.placeholderFontScale = 1
        birthDateTextField.backgroundColor =  UIColor(code: "#42A5F5")
        birthDateTextField.foregroundColor = UIColor.appColor()
        birthDateTextField.placeholderColor = UIColor.white
        birthDateTextField.placeholderFontScale = 1
        locateTextField.backgroundColor =  UIColor(code: "#42A5F5")
        locateTextField.foregroundColor = UIColor.appColor()
        locateTextField.placeholderColor = UIColor.white
        locateTextField.placeholderFontScale = 1
    }

    @IBAction func actionTouchBirthDateField(_ sender: Any) {
        birthDateTextField.text = getFormattedDateStr(date: Date())
        let datePicker = UIDatePicker()
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChange(sender:)), for: UIControlEvents.valueChanged)
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Calendar.current.startOfDay(for: Date()))
        
        birthDateTextField.inputView = datePicker
    }
    
    
    @IBAction func actionTouchLocateField(_ sender: Any) {
        
    }
    
    //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChange(sender:UIDatePicker) {
        birthDateTextField.text = getFormattedDateStr(date: sender.date)
    }
    
    private func getFormattedDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd";
        return dateFormatter.string(from: date)
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
