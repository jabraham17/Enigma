//
//  InformationVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/12/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//controller object for all information views
@IBDesignable class InformationVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    //the container view that will hold the information view crrently being displayed
    @IBOutlet var containerView: UIView!
    //the refrence to the segemtned control
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //button action to close this popup
    @IBAction func close(_ sender: UIButtonBorder) {
        //dismiss the view controler
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    //when the segemented controller changes, change what is contained in the container view
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
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

