//
//  EnigmaView.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/14/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//display information about the app
@IBDesignable class EnigmaView: UIView {
    
    //gets refrences to views in IB
    @IBOutlet var title: UILabel!
    @IBOutlet var text: UITextView!
    var contentView: UIView!
    
    //the presenting view contorller that contains this view
    var presentingVC: UIViewController?
    
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
        
        //get the text for the view
        let fileName = "EnigmaInformation"
        //read text file, type is nothing cuz there is no file type
        let textFile = Bundle.main.path(forResource: fileName, ofType: "")
        //error text file
        let errorTextFile = Bundle.main.path(forResource: "ErrorInformation", ofType: "")
        
        //since reading text throws an error, must be in a do-catch
        do {
            //get textFile content
            let textContent = try String(contentsOfFile: textFile ?? errorTextFile!, encoding: .ascii)
            
            //search throught the text for any links that are denotated by #start#link#end#, then apply the link within to the previous word, then remove the special markings from the text file
            let pattern = try NSRegularExpression(pattern: "((\\S+)#start#([^#]+)#end#)")
            
            //get all occurences of the match
            let matches = pattern.matches(in: textContent, range: NSRange(location: 0, length: (textContent.characters.count - 1)))
            
            //convert text to attributed text
            let attributedText = NSMutableAttributedString(string: textContent)
            
            //go through all the matchs and add links to them
            for match in matches.reversed() {
                
                //get the text, this is the second group
                let text = attributedText.attributedSubstring(from: match.rangeAt(2)).string
                //get the link, this is the third group
                let link = attributedText.attributedSubstring(from: match.rangeAt(3)).string
                
                //add a link attribute to each text
                attributedText.addAttribute(NSLinkAttributeName, value: link, range: match.rangeAt(1))
                //add an underline to each attribute that is matched
                attributedText.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: match.rangeAt(1))
                
                //replace whats been linked with the text only
                attributedText.replaceCharacters(in: match.rangeAt(1), with: text)
            }
            
            //set the font for the text
            attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: (attributedText.length - 1)))
            
            //put it as the text of the view
            text.attributedText = attributedText
            //set text view to the top
            text.setContentOffset(CGPoint.zero, animated: false)
        }
        catch {
        }

    }
    //get all taps by user on this view
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //if the point is contained in the textView, retunr the textView
        if text.frame.contains(point) {
            return text
        }
            //otherwise, return the contsiner
        else {
            return contentView
        }
        
    }
}

