//
//  UITextViewCustom.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 1/20/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol UITextViewCustomDelegate: class {
    //called when enter button is tapped, sends text to view controller, will be implemented in view controller acknolwding this protocol/delegate
    func enterButton(textView: UITextView, textOfView: String)
}

//make UITextView have border and a title
@IBDesignable class UITextViewCustom: UIView, UITextViewDelegate, UIScrollViewDelegate {

    //holds UITextViewCustomDelegate object, used to call enterButton for view controller
    weak var passingDelegate: UITextViewCustomDelegate?
    
    //gets refrences to views in IB
    @IBOutlet var title: UILabel!
    @IBOutlet var text: UITextView!
    @IBOutlet var divider: UIView!
    @IBOutlet var share: UIButton!
    var contentView: UIView!
    
    //wether or not field is editable
    var editable = false {
        //if set, update the text view
        didSet {
            text.isEditable = self.editable
            //show or hide share button
            showShareButton()
        }
    }
    
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
        
        //set the delegate
        text.delegate = self
    }
    //add exclusion path and show/hide share button
    func showShareButton() {
        //if not editable, add exclusion path and show share button
        if !editable {
            //show share button
            share.isHidden = false
            share.isEnabled = false
            
            //add exclusion path
            text.textContainer.exclusionPaths = [updateExclusion(offset: 0)]
        }
        //otherwise remove exclusion path and hide share button
        else {
            //hide share button
            share.isHidden = true
            share.isEnabled = true
            //remove paths
            text.textContainer.exclusionPaths.removeAll()
        }
    }
    //when the view changes
    func textViewDidChange(_ textView: UITextView) {
        //if there is a newline character
        if textView.text.contains("\n")
        {
            //replace all occurences of newline with a blank character
            let newText = textView.text.replacingOccurrences(of: "\n", with: "")
            //set the text of the textView
            textView.text = newText
            //pass the text to the view controller for encryption
            passingDelegate?.enterButton(textView: textView, textOfView: newText)
            //close the keyboard
            textView.resignFirstResponder()
        }
    }
    //when view has stopped moving
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //if its not editable update the exclusion area
        if !editable {
            text.textContainer.exclusionPaths = [updateExclusion(offset: scrollView.contentOffset.y)]
        }
    }
    //update exclusion area
    func updateExclusion(offset: CGFloat) -> UIBezierPath{
        //width and height same as share button
        //x value is (width of field - width of share button)
        //y value is (scrollView content offset + height of field - height of share button)
        let x = text.frame.width - share.frame.width
        let y = offset + text.frame.height - share.frame.height
        //make exclusion path
        let exclusionArea = UIBezierPath(rect: CGRect(x: x, y: y, width: share.frame.width, height: share.frame.height))
        return exclusionArea
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
    //field for divider color
    @IBInspectable var dividerColor: UIColor? {
        get {
            return divider.backgroundColor!
        }
        set {
            divider.backgroundColor = newValue
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
