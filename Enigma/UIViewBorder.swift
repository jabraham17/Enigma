//
//  UIViewBorder.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 5/8/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//make UIView have border
@IBDesignable class UIViewBorder: UIButton {
    
    //field for border width of view
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //field for border color of view
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    //field for corner radius of view
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}


