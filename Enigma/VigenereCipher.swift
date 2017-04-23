//
//  VigenereCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 4/23/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a Vigenere Cipher
class VigenereCipher: KeyedEncryption {
    
    /*
     Rules for a Vigenere Cipher
     text is encrypted using a tabula recta
     */
    
    //init with encryption type, will always be Vigenere
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Vigenere)
        self.key = key
    }
    //MARK: Encrption Code for Vigenere
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        return toBeEncrypted
    }
    //MARK: Decrption Code for Vigenere
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        return toBeDecrypted
    }
}
