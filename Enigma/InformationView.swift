//
//  InformationView.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/12/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//generic code for all of the iformation views
@IBDesignable class InformationView: UIView {
    
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
