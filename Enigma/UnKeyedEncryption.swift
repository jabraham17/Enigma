//
//  UnKeyedEncryption.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/7/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//super class for all unkeyed encryptions
class UnKeyedEncryption {
    
    //the encryption type, will always be UnKeyed
    let encryptionType = Global.EncryptionTypes.Types.UnKeyed
    //the specific encryption the subclass will set
    var encryption = Global.EncryptionTypes.Encryptions.None
    
    //init
    init() {
        self.encryption = .None
    }
    //init with encryption
    init(encryption: Global.EncryptionTypes.Encryptions) {
        self.encryption = encryption
    }
    //encrypt function, MUST BE OVERRIDEN
    func encrypt(_ toBeEncrypted: String) -> String {
        //tell user that this function cannot be used until overriden
        precondition(false, "Encrypt func must be overriden in a subclass")
        return ""
    }
    //decrypt function, MUST BE OVERRIDEN
    func decrypt(_ toBeDecrypted: String) -> String {
        //tell user that this function cannot be used until overriden
        precondition(false, "Decrypt func must be overriden in a subclass")
        return ""
    }
}
