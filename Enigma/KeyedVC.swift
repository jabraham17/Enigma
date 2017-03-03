//
//  Keyed.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/28/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

@IBDesignable class KeyedVC: UIViewController, EncryptionNameHeaderDelegate, EncryptionSelectionDelegate, UITextViewCustomDelegate, UIPopoverPresentationControllerDelegate {
    
    //the header view from storyboard
    @IBOutlet var headerView: EncryptionNameHeader!
    //text fields
    @IBOutlet var unencryptedField: UITextViewCustom!
    @IBOutlet var encryptedField: UITextViewCustom!
    
    //positions for encryption text views
    var topPosition: CGPoint = CGPoint()
    var bottomPosition: CGPoint = CGPoint()
    
    //encrytion class
    var encryptor: KeyedEncryption = KeyedEncryption(encryption: .None)
    
    //holds which field is currently on top/allowed to be edited
    var currentField: Global.TypesOfField = .None
    //update the view to reflect currentField
    func updateView() {
        //if current field is unencrypted, put it at the top, then enable it
        if currentField == .Unencrypted {
            unencryptedField.frame.origin = topPosition
            unencryptedField.editable = true
            encryptedField.frame.origin = bottomPosition
            encryptedField.editable = false
        }
            //if currentField is encrypted, put it at the top, then enable it
        else if currentField == .Encrypted {
            encryptedField.frame.origin = topPosition
            encryptedField.editable = true
            unencryptedField.frame.origin = bottomPosition
            unencryptedField.editable = false
        }
    }
    //change currentField on switch click
    @IBAction func switchAction(_ sender: UIButtonBorder) {
        //if unencrypt, change to encrypt
        if currentField == .Unencrypted {
            currentField = .Encrypted
        }
            //if encrypt, change to unencrypt
        else if currentField == .Encrypted {
            currentField = .Unencrypted
        }
        updateView()
    }
    
    //current encryption
    var currentEncyption: Global.EncryptionTypes.Encryptions = .None {
        //if encryption was set, update the header label: this is done in setEncryption
        didSet {
            //update encryption
            setEncryption()
        }
    }
    //current encryption type, only changes when moving to new view
    var currentEncyptionType: Global.EncryptionTypes.Types = .Keyed

    //when the screen loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add listener for when to save data
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: NSNotification.Name(rawValue: "saveAllData"), object: nil)
        
        //add delegate to header
        headerView.delegate = self
        
        //disable the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //set the delegates for the text views
        unencryptedField.passingDelegate = self
        encryptedField.passingDelegate = self
        
        
        //update the encryption
        setEncryption()
    }
    //when the view will diaspear
    override func viewWillDisappear(_ animated: Bool) {
        //post notifivtion to disapppear
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveAllData"), object: nil)
        //remove all notification listeners
        NotificationCenter.default.removeObserver(self)
    }
    //after the view has appeared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //get the inital positions of the encryot fields set them to the top and bottom positions
        //get the initila positions
        let unencrpytedPos = unencryptedField.frame.origin
        let encrpytedPos = encryptedField.frame.origin
        //if th current field is unencrypted,put it on top
        if currentField == .Unencrypted
        {
            topPosition = unencrpytedPos
            bottomPosition = encrpytedPos
        }
        //if th current field is encrypted,put it on top
        if currentField == .Encrypted
        {
            topPosition = encrpytedPos
            bottomPosition = unencrpytedPos
        }
        //update the view to reflect what it should look like
        updateView()
    }
    //on deinit of class
    deinit {
        //remove all notification listeners
        NotificationCenter.default.removeObserver(self)
    }
    //save all data
    func saveData() {
        //save current position
        UserData.sharedInstance.setLastUsedEncryptionType(currentEncyptionType)
        UserData.sharedInstance.setLastUsedEncryption(currentEncyption)
        UserData.sharedInstance.setLastUsedField(currentField)
    }
    //override from EncryptionNameHeaderDelegate, used to determine when the NavigationBar header was tapped
    //when tapped, open EncryptionSelection
    func headerWasTapped() {
        
        //close the keyboard
        //if the current field is unencrypted
        if currentField == .Unencrypted
        {
            //close unecrntpted fields keyboard
            unencryptedField.text.resignFirstResponder()
        }
            //if the current field is encrypted
        else if currentField == .Encrypted
        {
            //close ecrntpted fields keyboard
            encryptedField.text.resignFirstResponder()
        }
        
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
        //dismiss keyboard
        textView.resignFirstResponder()
        
        //show warning
        /*warning(text: "warning message", cancelAction: {
         //cancel action
         
         },
         continueAction: {
         //continue action
         
         })
         
         //show error
         error(text: "error message", okAction: {
         //ok action
         
         })*/
        
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
    //make warning popup
    func warning(text: String, cancelAction: (() -> Void)?, continueAction: (() -> Void)?) {
        //load vc from nib
        let nib = UINib(nibName: String(describing: WarningVC.self), bundle: Bundle(for: WarningVC.self))
        
        let warning = nib.instantiate(withOwner: self, options: nil)[0] as! WarningVC
        //setup with info
        warning.setup(text: text, cancelAction: cancelAction, continueAction: continueAction)
        
        //make presentation so warning appears over container vc
        warning.modalPresentationStyle = .overFullScreen
        //set delaget for custom presentation
        let transDel = PopupAnimatorDelegate()
        warning.transitioningDelegate = transDel
        
        //show warning
        self.present(warning, animated: true, completion: nil)
    }
    //make warning popup
    func error(text: String, okAction: (() -> Void)?) {
        //load vc from nib
        let nib = UINib(nibName: String(describing: ErrorVC.self), bundle: Bundle(for: ErrorVC.self))
        
        let error = nib.instantiate(withOwner: self, options: nil)[0] as! ErrorVC
        //setup with info
        error.setup(text: text, okAction: okAction)
        
        //make presentation so error appears over container vc
        error.modalPresentationStyle = .overFullScreen
        //set delaget for custom presentation
        let transDel = PopupAnimatorDelegate()
        error.transitioningDelegate = transDel
        
        //show error
        self.present(error, animated: true, completion: nil)
    }
    //if the share button was tapped, share the text
    func shareButton(senderButton: UIButton, textToShare: String) {
        //creat the activity controller to share the text
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        //excluded certian types
        activityVC.excludedActivityTypes = [.airDrop, .assignToContact, .addToReadingList, .openInIBooks, .postToFlickr, .postToTencentWeibo, .postToVimeo, .postToWeibo, .saveToCameraRoll]
        
        //present as a popover
        activityVC.popoverPresentationController?.sourceView = senderButton
        self.present(activityVC, animated: true, completion: nil)
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
                //set the new encryption and encryotin type
                currentEncyption = encryption
                currentEncyptionType = encryptionType
                //save all the data
                saveData()
                //unwind the segue, this pops current view off the stack
                _ = self.navigationController?.popViewController(animated: false)
            }
        }
    }
    //set the current encryption type
    func setEncryption() {
        
        //update the header
        headerView.name.text = self.currentEncyption.description
        
        /*switch currentEncyption {
        //if _, make _ encryption
        case ._:
            encryptor = _()
            break
        default:
            //shouldnt ever get here
            break
        }*/
    }
    //delegate function from UIPopoverControllerDelegate
    //present in popover style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


