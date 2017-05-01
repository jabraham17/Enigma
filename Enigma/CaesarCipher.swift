//
//  CaesarCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/6/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a caesar cipher
class CaesarCipher: KeyedEncryption {
    
    /*
     Rules for a Caesar Cipher
     Each character is shifted by the key
     If key is 0, no change occurs
     If key is 26, no change occurs
     If key is creater than 26, take the remandier of (key / 26) and that is the key
     */
    
    //init with encryption type, will always be Caesar
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Caesar)
        self.key = key
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        //MARK: show view saying key out of range
        //specific key for encryption, this is simply the key from the super class in int form
        var specificKey = Int(key)
        //if its nil, set it to 0
        if specificKey == nil {
            specificKey = 0
        }
        
        //get a array of all of the characters
        let unencryptedText = Array(toBeEncrypted.characters)
        //array to hold the encrypted text
        var encryptedText = [Character]()
        //loop through all the characters
        for var c in unencryptedText
        {
            //convert the character to a byte
            var b = toByte(c: c)
            
            //if c is an uppercase letter
            if Global.uppercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_A) + UInt16(specificKey!)) % 26
                b += byteValue_A
            }
                //if c is a lowercase letter
            else if Global.lowercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_a) + UInt16(specificKey!)) % 26
                b += byteValue_a
            }
            //otherwise dont encrypt
            
            //convert the shifted byte to character
            c = toCharacter(b: b)
            //add the encrypted character to the array of ecncrypted text
            encryptedText.append(c)
        }
        //convert the encrypted array to a string
        let encryptedString = String(encryptedText)
        //return the ecrypted text
        return encryptedString
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        //specific key for decrytion, this is simply the key from the super class in int form
        var specificKey = Int(key)
        //if its nil, set it to 0
        if specificKey == nil {
            specificKey = 0
        }
        
        //get a array of all of the characters
        let encryptedText = Array(toBeDecrypted.characters)
        //array to hold the unencrypted text
        var unencryptedText = [Character]()
        //loop through all the characters
        for var c in encryptedText
        {
            //convert the character to a byte
            var b = toByte(c: c)
            
            //if c is an uppercase letter
            if Global.uppercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_A) - UInt16(specificKey!)) % 26
                b += byteValue_A
            }
                //if c is a lowercase letter
            else if Global.lowercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_a) - UInt16(specificKey!)) % 26
                b += byteValue_a
                
            }
            //otherwise dont decrypt
            
            //convert the shifted byte to character
            c = toCharacter(b: b)
            //add the unencrypted character to the array of unecncrypted text
            unencryptedText.append(c)
        }
        //convert the unencrypted array to a string
        let unencryptedString = String(unencryptedText)
        //return the unecrypted text
        return unencryptedString
    }
}

