//
//  XORCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/8/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a xor cipher
class XORCipher: KeyedEncryption {
    
    /*
     Rules for a XOR Cipher
     Each character is shifted by a bitwise transformation of a key and the chararcter
     Same shift undoes the encryption
     */
    
    
    //init with encryption type, will always be XOR
    //init inputed key value
    init(key: String) {
        super.init(encryption: .XOR)
        self.key = key
    }
    //put ecnryptin code here
    override func encrypt(_ toBeEncrypted: String) -> String {
        //apply shift and return
        return bitwiseShift(s: toBeEncrypted)
    }
    //put decryption code here
    override func decrypt(_ toBeDecrypted: String) -> String {
        //apply shift and return
        return bitwiseShift(s: toBeDecrypted)
    }
    
    //FIXME: fix XOR with this alogirth, http://stackoverflow.com/questions/28144796/swift-simple-xor-encryption
    
    //applies bitwise xor shift
    func bitwiseShift(s: String) -> String {
        //MARK: show view saying key out of range
        //specific key for encryption, this is simply the key from the super class in int form
        var specificKey = Int(key)
        //if its nil, set it to 0
        if specificKey == nil {
            specificKey = 0
        }
        
        //get a array of all of the characters
        let regularText = Array(s.characters)
        //array to hold the shifted text
        var shiftedText = [Character]()
        //loop through all the characters
        for var c in regularText
        {
            //convert the character to a byte
            var b = UInt8(toByte(c: c))
            
            //perform bitwise shift, convert key to UInt16 to allow bitwise shift
            b = b ^ UInt8(exactly: specificKey!)!
            
            print(b)
            
            //convert the shifted byte to character
            c = toCharacter(b: UInt16(b))
            //add the shifted character to the array of shifted text
            shiftedText.append(c)
        }
        //convert the encrypted array to a string
        let shiftedString = String(shiftedText)
        //return the ecrypted text
        return shiftedString
    }
}

