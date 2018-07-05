//
//  UIVew+GradationView.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/07/06.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//
import UIKit

@IBDesignable
class GradationView: UIView {
    
    var gradientLayer: CAGradientLayer?
    
    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            setGradation()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            setGradation()
        }
    }
    
    private func setGradation() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer!.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer!.frame.size = frame.size
        layer.addSublayer(gradientLayer!)
        layer.masksToBounds = true
    }
}
