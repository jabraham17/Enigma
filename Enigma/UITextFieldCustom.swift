//
//  UITextFieldCustom.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/1/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol UITextFieldCustomDelegate: class {
    //called when enter button is tapped, sends text to view controller, will be implemented in view controller acknolwding this protocol/delegate
    func enterButton(textField: UITextField, textOfField: String)
    //called when share button is tapped, sends text to view controller, will be implemented in view controller acknolwding this protocol/delegate
    func shareButton(senderButton: UIButton, keyToShare: String)
}

//make UITextField have border and a title
@IBDesignable class UITextFieldCustom: UIView, UITextFieldDelegate {
    //holds UITextViewCustomDelegate object, used to call enterButton for view controller
    weak var passingDelegate: UITextFieldCustomDelegate?
    
    //gets refrences to views in IB
    @IBOutlet var title: UILabel!
    @IBOutlet var field: UITextField!
    var contentView: UIView!
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup the nib
        setupNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup the nib
        setupNib()
    }
    //setup the nib
    func setupNib() {
        //get the nib as a view
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        //set the content view so that it is the same size as the view
        contentView.frame = bounds
        
        //setup view so that if screen is resized the view stretches with it
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(contentView)
        
        //set the fields delegate
        field.delegate = self
        
        //setup assecary bar so that there can be a done button on the keyField keyboard
        //get a tool bar
        let keyboardToolbar = UIToolbar()
        //size it to be right size for screen
        keyboardToolbar.sizeToFit()
        //make the button, action dismisses the keyboard
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        //set it as the bars items
        keyboardToolbar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneBarButton]
        //add the tool bar to the keyboard
        field.inputAccessoryView = keyboardToolbar
        //by default, this toolbar is hidden
        field.inputAccessoryView?.isHidden = true
    }
    //wether or not tool bar for keyboad is hidden
    var keyboardToolBarHidden: Bool {
        get {
            //return the value of the toolbars visibilty
            return (self.field.inputAccessoryView?.isHidden)!
        }
        set(newValue) {
            //once its been set, set the same value to the tool bar itself
            self.field.inputAccessoryView?.isHidden = newValue
        }
    }
    //fucntion toclose the keyboard
    func close() {
        //pass the text to the view controller for encryption so that text gets updated
        passingDelegate?.enterButton(textField: field, textOfField: field.text!)
        field.resignFirstResponder()
    }
    //allow returns on the text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //pass the text to the view controller for encryption
        passingDelegate?.enterButton(textField: textField, textOfField: textField.text!)
        //close the keyboard
        textField.resignFirstResponder()
        return true
    }
    //sender button clicked, send the text to the delegate
    @IBAction func shareAction(_ sender: UIButtonBorder) {
        //get the text and pass it
        passingDelegate?.shareButton(senderButton: sender, keyToShare: field.text!)
    }
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
    //field for title text
    @IBInspectable var titleText: String? {
        get {
            return title.text
        }
        set {
            title.text = newValue
        }
    }
}

