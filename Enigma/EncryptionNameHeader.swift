//
//  EncryptionNameHeader.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/2/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol EncryptionNameHeaderDelegate: class {
    //called when view is tapped, will be implemented in view controller acknolwding this protocol/delegate
    func headerWasTapped()
}

//custom header for navigation bar
@IBDesignable class EncryptionNameHeader: UIView {
    
    //holds EncryptionNameHeaderDelegate object, used to call headerWasTapped for view controller
    weak var delegate: EncryptionNameHeaderDelegate?
    
    //gets refrences to views in IB
    @IBOutlet var name: UILabel!
    var contentView: UIView!
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup the nib
        setupNib()
        //setup the tap gesture
        setupTap()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup the nib
        setupNib()
        //setup the tap gesture
        setupTap()
    }
    //setup tap gestures
    func setupTap() {
        //create the tap geture recognizer
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        //add it to the view
        contentView.addGestureRecognizer(gesture)
    }
    //action for tap gesture, simply calls delegate method headerWasTapped
    func viewTapped() {
        delegate?.headerWasTapped()
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
        
        self.addSubview(contentView);
        
    }
    
    //field for title text
    @IBInspectable var encryptionName: String? {
        get {
            return name.text
        }
        set {
            name.text = newValue
        }
    }
    //field for backgorund color
    @IBInspectable var background: UIColor? {
        get {
            return contentView.backgroundColor
        }
        set {
            contentView.backgroundColor = newValue
        }
    }
}
