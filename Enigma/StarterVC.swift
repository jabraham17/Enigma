//
//  StarterVC.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/14/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//class is first loaded when app loaded, opens last used encryption
class StarterVC: UIViewController {
    
    var lastUsedType: Global.EncryptionTypes.Types = .None
    var lastUsedEncryption: Global.EncryptionTypes.Encryptions = .None
    var lastUsedField: Global.TypesOfField = .None
    
    //called just before view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //load in the last used encryption type
        lastUsedType = UserData.sharedInstance.getLastUsedEncryptionType()
        //if the last used encryption type is .None, ie first time app is run, set it to UnKeyed
        if lastUsedType == .None {
            lastUsedType = .UnKeyed
        }
        //load in the last used encryption
        lastUsedEncryption = UserData.sharedInstance.getLastUsedEncryption()
        //if the last used encryption is .None, ie first time app is run, set it to PigLatin
        if lastUsedEncryption == .None {
            lastUsedEncryption = .PigLatin
        }
        //load in the last used field
        lastUsedField = UserData.sharedInstance.getLastUsedField()
        //if the last used field is .None, ie first time app is run, set it to Unencrypted
        if lastUsedField == .None {
            lastUsedField = .Unencrypted
        }
        
        //perform segue to last used encryption type controller
        self.performSegue(withIdentifier: "StarterTo" + lastUsedType.description, sender: nil)
    }
    //pass last used encryption and field to vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //determine what kind it should be based on the last used encryption type
        switch lastUsedType {
        case .UnKeyed:
            //get destination vc as UnKeyedVC
            let vc = segue.destination as! UnKeyedVC
            
            //set last used field and encryption
            vc.currentEncyption = lastUsedEncryption
            vc.currentField = lastUsedField
            
            break
        case .Keyed:
            //get destination vc as KeyedVC
            let vc = segue.destination as! KeyedVC
            
            //set last used field and encryption
            vc.currentEncyption = lastUsedEncryption
            vc.currentField = lastUsedField
            
            break
        default:
            //never should reach here
            break
        }
    }
}
