//
//  RailFenceCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/11/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a rail fence cipher
class RailFenceCipher: KeyedEncryption {
    
    /*
     Rules for a Rail Fence Cipher
     This cipher simply scrambles the text in a particular pattern
     the text is written letter by letter down 'rails', moving up when it reaches the bottom
     the text is then read rail by rail to produce the encrypted text
     the key refers to the number of rails
     */
    
    //init with encryption type, will always be RailFence
    //init inputed key value
    init(key: String) {
        super.init(encryption: .RailFence)
        self.key = key
    }
    //MARK: Encrption Code for rail fence
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        return toBeEncrypted
    }
    //MARK: Decrption Code for rail fence
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        return toBeDecrypted
    }
}
