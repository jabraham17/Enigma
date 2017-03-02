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
    func enterButton(textView: UITextView, textOfView: String)
    //called when share button is tapped, sends text to view controller, will be implemented in view controller acknolwding this protocol/delegate
    func shareButton(senderButton: UIButton, textToShare: String)
}

//make UITextField have border and a title
@IBDesignable class UITextFieldCustom: UIView {
    //holds UITextViewCustomDelegate object, used to call enterButton for view controller
    weak var passingDelegate: UITextViewCustomDelegate?
    
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
        
        // FIXME: set the delegate
    }
    //sender button clicked, send the text to the delegate
    @IBAction func shareAction(_ sender: UIButtonBorder) {
        //get the text and pass it
        passingDelegate?.shareButton(senderButton: sender, textToShare: field.text!)
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

