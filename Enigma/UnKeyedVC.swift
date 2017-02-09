//
//  UnKeyedVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 1/20/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//view controller for unkeyed encryptions
class UnKeyedVC: UIViewController, EncryptionNameHeaderDelegate, EncryptionSelectionDelegate, UITextViewCustomDelegate, UIPopoverPresentationControllerDelegate {
    
    //the header view from storyboard
    @IBOutlet var headerView: EncryptionNameHeader!
    //text fields
    @IBOutlet var unencryptedField: UITextViewCustom!
    @IBOutlet var encryptedField: UITextViewCustom!
    
    //positions for encryption text views
    var topPosition: CGPoint = CGPoint()
    var bottomPosition: CGPoint = CGPoint()
    
    //encrytion class
    var encryptor: UnKeyedEncryption = UnKeyedEncryption(encryption: .None)
    
    //holds which field is currently on top/allowed to be edited
    var currentField: Global.TypesOfField = .None {
        //if currentField was changed, update the view accordingly
        didSet {
            updateView()
        }
    }
    //update the view to reflect currentField
    func updateView() {
        //if current field is unencrypted, put it at the top, then enable it
        if currentField == Global.TypesOfField.Unencrypted {
            unencryptedField.frame.origin = topPosition
            unencryptedField.editable = true
            encryptedField.frame.origin = bottomPosition
            encryptedField.editable = false
        }
        //if currentField is encrypted, put it at the top, then enable it
        else if currentField == Global.TypesOfField.Encrypted {
            encryptedField.frame.origin = topPosition
            encryptedField.editable = true
            unencryptedField.frame.origin = bottomPosition
            unencryptedField.editable = false
        }

    }
    //change currentField on switch click
    @IBAction func switchAction(_ sender: UIButtonBorder) {
        //if unencrypt, change to encrypt
        if currentField == Global.TypesOfField.Unencrypted {
            currentField = .Encrypted
        }
        //if encrypt, change to unencrypt
        else if currentField == Global.TypesOfField.Encrypted {
            currentField = .Unencrypted
        }
    }
    
    //current encryption
    var currentEncyption: Global.EncryptionTypes.Encryptions = .None {
        //if encryption was set, update the header label
        didSet {
            headerView.name.text = self.currentEncyption.description
            //update encryption
            setEncryption()
        }
    }
    //current encryption type, never changes
    let currentEncyptionType: Global.EncryptionTypes.Types = .UnKeyed
    
    //when the screen loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add delegate to header
        headerView.delegate = self
        
        //get the inital positions of the encryot fields set them to the top and bottom positions
        topPosition = unencryptedField.frame.origin
        bottomPosition = encryptedField.frame.origin
        
        //set the delegates for the text views
        unencryptedField.passingDelegate = self
        encryptedField.passingDelegate = self
        
        //MARK: Will be fixed in future to read from save what the last opened encryption is
        currentEncyption = .PigLatin
        
        //MARK: Will be fixed in future to read from save what the currentField is
        currentField = .Unencrypted
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
    //if the enter button was tapped, determine wether to encryt or decrupt, then do so
    func enterButton(textView: UITextView, textOfView: String) {
        //if the text view is the unecrypted, encrypt text and output to encrypted
        if textView == unencryptedField.text
        {
            let encryptedText = encryptor.encrypt(textOfView)
            encryptedField.text.text = encryptedText
        }
        //if the text view is the ecrypted, decrypt text and output to unencrypted
        else if textView == encryptedField.text
        {
            let unencryptedText = encryptor.decrypt(textOfView)
            unencryptedField.text.text = unencryptedText
        }
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
    //set the current encryption type
    func setEncryption() {
        switch currentEncyption {
        //if pig latin, make pig latin encryption
        case .PigLatin:
            //encryptor = PigLatin()
            break
        //if morse code, make morse code encryption
        case .MorseCode:
            //encryptor = MorseCode()
            break
        //if rot13, make rot13 encryption
        case .ROT13:
            encryptor = ROT13()
            break
        default:
            //shouldnt ever get here
            break
        }
    }
    //delegate function from UIPopoverControllerDelegate
    //present in popover style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

