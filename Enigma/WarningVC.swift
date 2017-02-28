//
//  WarningVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/17/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//display warnings to user
@IBDesignable class WarningVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    //gets refrences to views in IB
    @IBOutlet var textView: UITextView!
    
    //actions for cancelButton and continueButton
    var cancelAction: (() -> Void)?
    var continueAction: (() -> Void)?
    
    //setups up warning with text and butto actions
    func setup(text: String, cancelAction: (() -> Void)?, continueAction: (() -> Void)?)
    {
        //set text
        textView.text = text
        //set the actions for the buttons
        self.cancelAction = cancelAction
        self.continueAction = continueAction
    }
    //required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //cancel button action, call cancelAction and close vc
    @IBAction func cancelButton(_ sender: UIButton) {
        //defered to ensure it is performed no matter what, dismiss vc
        defer {
            presentingViewController!.dismiss(animated: true, completion: nil)
        }
        
        //get function to call from action
        guard let action = cancelAction else {return}
        //call function
        action()
    }
    //continue button action, call continueAction and close vc
    @IBAction func continueButton(_ sender: UIButton) {
        //defered to ensure it is performed no matter what, dismiss vc
        defer {
            presentingViewController!.dismiss(animated: true, completion: nil)
        }
        
        //get function to call from action
        guard let action = continueAction else {return}
        //call function
        action()
        /*presentingViewController!.dismiss(animated: true, completion: {
            //get function to call from action
            guard let action = self.continueAction else {return}
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
