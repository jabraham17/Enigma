//
//  WarningView.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/17/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//display warnings to user
@IBDesignable class WarningView: UIView {
    
    //gets refrences to views in IB
    @IBOutlet var title: UILabel!
    @IBOutlet var text: UITextView!
    @IBOutlet var ok: UIButtonBorder!
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
    }
}
