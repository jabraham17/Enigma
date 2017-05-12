//
//  CurrentEncryptionInformation.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/12/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//display information about the current encryption
@IBDesignable class CurrentEncryptionInformationView: UIView {
    
    //gets refrences to views in IB
    @IBOutlet var title: UILabel!
    @IBOutlet var text: UITextView!
    var contentView: UIView!
    
    //the presenting view contorller that contains this view
    var presentingVC: UIViewController?
    
    //the current encryption thats being displayed
    var currentEncryption: Global.EncryptionTypes.Encryptions = .None {
        //when the encryption has been set
        didSet {
            //get encryption name
            let name = currentEncryption.description
            //set the title to be the encryption name
            title.text = name
            
            //use short name for information file titles
            let fileName = currentEncryption.shortName + "Information"
            //read text file, type is nothing cuz there is no file type
            let textFile = Bundle.main.path(forResource: fileName, ofType: "")
            //error text file
            let errorTextFile = Bundle.main.path(forResource: "ErrorInformation", ofType: "")
            
            //since reading text throws an error, must be in a do-catch
            do {
                //get textFile content
                let textContent = try String(contentsOfFile: textFile ?? errorTextFile!, encoding: .utf8)
                
                //search throught the text for any exponents that are denotated by #start#base^power#end#, then replace the ^power with a superscript of the power
                let pattern = try NSRegularExpression(pattern: "(#start#(\\d+)\\^(\\d+)#end#)")
                
                //get all occurences of the match
                let matches = pattern.matches(in: textContent, range: NSRange(location: 0, length: (textContent.characters.count - 1)))
                
                //convert text to attributed text
                let attributedText = NSMutableAttributedString(string: textContent)
                
                //do this before all the matches are done, if there are any. this is so that if a font value is changed it will not be overwritten by this call
                //set the font for the text
                attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: (attributedText.length - 1)))
                
                //go through all the matchs and replace powers with superscripts
                for match in matches.reversed() {
                    
                    //get the base, this is the second group
                    let base = attributedText.attributedSubstring(from: match.rangeAt(2)).string
                    //get the power, this is the third group
                    let power = attributedText.attributedSubstring(from: match.rangeAt(3)).string
                    
                    //add a superscript attribute to text in match
                    attributedText.addAttribute(NSBaselineOffsetAttributeName, value: 9, range: match.rangeAt(1))
                    //make the superscript smaller than the rest of the text
                    attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10), range: match.rangeAt(1))
                    
                    //replace whats been linked with the power
                    attributedText.replaceCharacters(in: match.rangeAt(1), with: power)
                    
                    //insert the base just before the match
                    attributedText.insert(NSAttributedString(string: base), at: match.rangeAt(1).location)
                    
                    //make the recently added base the same font as the rest of the string
                    attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: match.rangeAt(1).location, length: base.characters.count))
                }
                //put it as the text of the view
                text.attributedText = attributedText
                print(text.contentOffset)
                //MARK: contetn offset is wrong, the text is not scrolling to top
                //set text view to the top
                text.setContentOffset(CGPoint.zero, animated: false)
                print(text.contentOffset)
            }
            catch {
            }
        }
    }
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup
        setupNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup
        setupNib()
    }
    //setup view from nib
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
        
        //set the current encyrption to the curent one one
        self.currentEncryption = UserData.sharedInstance.getLastUsedEncryption()
        
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
