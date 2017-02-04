//
//  UnKeyedVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 1/20/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//view controller for unkeyed encryptions
class UnKeyedVC: UIViewController, EncryptionNameHeaderDelegate, UIPopoverPresentationControllerDelegate {
    
    var currentEncyption = Global.EncryptionTypes.Encryptions.None
    
    //when the screen loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //added delegate to NaviagtionBar Header
        //get the title view as a EncryptionNameHeader
        let titleView = self.navigationItem.titleView as! EncryptionNameHeader
        //let titleView = self.navigationController?.navigationItem.titleView as! EncryptionNameHeader
        //set the delegate
        titleView.delegate = self
        
        //MARK: Will be fixed in future to read from save what the last opened encryption is
        currentEncyption = Global.EncryptionTypes.Encryptions.PigLatin
        //set the title of the screen to the current encryption
        titleView.name.text = currentEncyption.description
    }
    //override from EncryptionNameHeaderDelegate, used to determine when the NavigationBar header was tapped
    //when tapped, open EncryptionSelection
    func headerWasTapped() {
        
        //get the view controller
        let selectionVC = EncryptionSelection()
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
    
    //delegate function from UIPopoverControllerDelegate
    //present in popover style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

