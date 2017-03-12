//
//  TranspositionCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/11/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a transposition cipher
class TranspositionCipher: KeyedEncryption {
    
    /*
     Rules for a Transposition Cipher
     
     */
    
    //init with encryption type, will always be Trans
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Trans)
        self.key = key
    }
    //MARK: Encrption Code for transposition
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        return toBeEncrypted
    }
    //MARK: Decrption Code for transposition
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        return toBeDecrypted
    }
}

