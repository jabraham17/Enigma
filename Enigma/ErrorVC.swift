//
//  ErrorVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/28/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//display errors to user
@IBDesignable class ErrorVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    //gets refrences to views in IB
    @IBOutlet var textView: UITextView!
    
    //action for ok button
    var okAction: (() -> Void)?
    
    //setups up error with text and ok action
    func setup(text: String, okAction: (() -> Void)?)
    {
        //set text
        textView.text = text
        //set the action for ok buttn
        self.okAction = okAction
    }
    //required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //ok button action, call okAction and close vc
    @IBAction func continueButton(_ sender: UIButton) {
        //defered to ensure it is performed no matter what, dismiss vc
        defer {
            presentingViewController!.dismiss(animated: true, completion: nil)
        }
        
        //get function to call from action
        guard let action = okAction else {return}
        //call function
        action()
        /*presentingViewController!.dismiss(animated: true, completion: {
         //get function to call from action
         guard let action = self.okAction else {return}
         //call function
         action()
         })*/
    }
    //field for border width of view
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.view.layer.borderWidth
        }
        set {
            self.view.layer.borderWidth = newValue
        }
    }
    //field for border color of view
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.view.layer.borderColor!)
        }
        set {
            self.view.layer.borderColor = newValue?.cgColor
        }
    }
    //field for corner radius of view
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.view.layer.cornerRadius
        }
        set {
            self.view.layer.cornerRadius = newValue
        }
    }
}

