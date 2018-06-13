//
//  UIImageView+AlamofireImage.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/13.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImageByAlamofire(with url: URL) {
        
        af_setImage(withURL: url) { [weak self] response in
            switch response.result {
            case .success(let image):
                self?.image = image
                
            case .failure(_):
                // error handling
                break
            }
            
        }
    }
}
