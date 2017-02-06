//
//  UnKeyedVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 1/20/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//view controller for unkeyed encryptions
class UnKeyedVC: UIViewController, EncryptionNameHeaderDelegate, EncryptionSelectionDelegate, UIPopoverPresentationControllerDelegate {
    
    //the header view from storyboard
    @IBOutlet var headerView: EncryptionNameHeader!
    
    
    //current encryption
    var currentEncyption = Global.EncryptionTypes.Encryptions.None {
        //on set, set the currentEncryption to the new value and update the label
        didSet {
            headerView.name.text = self.currentEncyption.description
        }
    }
    //current encryption type, never changes
    let currentEncyptionType = Global.EncryptionTypes.Types.UnKeyed
    
    //when the screen loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add delegate to header
        headerView.delegate = self
        
        //MARK: Will be fixed in future to read from save what the last opened encryption is
        currentEncyption = Global.EncryptionTypes.Encryptions.PigLatin
    }
    //override from EncryptionNameHeaderDelegate, used to determine when the NavigationBar header was tapped
    //when tapped, open EncryptionSelection
    func headerWasTapped() {
        
        //get the view controller
        let selectionVC = EncryptionSelection()
        //set the delegate
        selectionVC.delegate = self
        //set the current encryption of the selection view controller
        selectionVC.currentEncyption = currentEncyption
        //set the preferred size of the popup
        selectionVC.preferredContentSize = CGSize(width: Global.xUnit * 17, height: Global.yUnit * 20)
        
        
        //set the presentation style to popover
        selectionVC.modalPresentationStyle = .popover
        
        //setup as a popover view controller
        let popover = selectionVC.popoverPresentationController!
        //set the delegate as this class
        popover.delegate = self
        //anchor the popover to the title view
        popover.sourceView = self.navigationItem.titleView
        popover.sourceRect = (self.navigationItem.titleView?.bounds)!
        
        //present the popover
        present(selectionVC, animated: true, completion:nil)
    }
    //override from EncryptionSelectionDelegate, used to determine which encryption was selected
    //if current encryption, do nothing, otherwise change to anther encryption
    func encryptionSelected(encryptionType: Global.EncryptionTypes.Types, encryption: Global.EncryptionTypes.Encryptions) {
        
        //if the encryption selected is not the same as the current encryption
        if currentEncyption != encryption {
            //if its of the same type of encryption, change current encryption to the new one
            if currentEncyptionType == encryptionType {
                currentEncyption = encryption
            }
            //otherwise, change to another encryption type
            else {
                // TODO: CHange to another type
            }
        }
    }
    //delegate function from UIPopoverControllerDelegate
    //present in popover style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

