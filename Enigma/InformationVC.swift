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
    @IBOutlet var containerView: InformationView!
    //the refrence to the segemtned control
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //all information about current encryption goes here
    let currentEncryptionInformationView = CurrentEncryptionInformationView()
    //all information about the app goes here
    let enigmaView = EnigmaView()
    //the store view goes here
    let storeView = StoreView()
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //setups up view, param is starting view index
    func setup(startingIndex: Global.SegmentedControlIndex)
    {
        //set the index for the segemented controller
        segmentedControl.selectedSegmentIndex = startingIndex.rawValue
        
        //setup storeViews view controller
        storeView.presentingVC = self
        
        //update view
        updateContainerView()
    }
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
        updateContainerView()
    }
    //updates container view with the view dictated by the segemented control
    func updateContainerView() {
        
        //rmeove all subviews of the conatiner view to prepare for the new one
        //loop through and remove each subview
        containerView.subviews.forEach({$0.removeFromSuperview()})
        
        //determine which segement is selected
        switch segmentedControl.selectedSegmentIndex {
        //if its CurrentEncryption
        case Global.SegmentedControlIndex.Current.rawValue:
            //add current encryption view as subview to conatiner view
            containerView.addSubview(currentEncryptionInformationView)
            break
        //if its Enigma
        case Global.SegmentedControlIndex.Enigma.rawValue:
            //add app information view as subview to conatiner view
            containerView.addSubview(enigmaView)
            break
        //if its Store
        case Global.SegmentedControlIndex.Store.rawValue:
            //add the store view as subview to conatiner view
            containerView.addSubview(storeView)
            break
        default:
            //shoudlnt ever get here
            break
        }
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

