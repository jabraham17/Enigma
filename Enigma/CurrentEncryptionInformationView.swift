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
            
            //since reading text throws an error, must be in a do-catch
            do {
                //get textFile content
                let textContent = try String(contentsOfFile: textFile!, encoding: .ascii)
                
                //put it as the text of the view
                text.text = textContent
            }
            catch {
                //TODO: Show an error view
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
}
