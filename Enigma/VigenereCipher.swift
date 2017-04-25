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
     text is encrypted using a rotating caesar cipher
     through each iteration of the encryption on each caharcter, the key is rotated
     
     */
    
    //init with encryption type, will always be Vigenere
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Vigenere)
        self.key = key
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        
        //get a array of all of the characters
        let unencryptedText = Array(toBeEncrypted.characters)
        
        //synthses the key, repeat it until run out of chars in unencryted
        //if the key is blank, then simply return the text to be encrypted so no divide by zero results
        if key.isEmpty
        {
            return toBeEncrypted
        }
        //num of keys that will fit in the text
        let keysInText = Int(unencryptedText.count / key.characters.count)
        //get remainder of space in text that a whole key phrase will jot fit in
        let extraSpaceInText = Int(unencryptedText.count % key.characters.count)
        //extended key, not includogn the extra space yet
        var extendedKey = String(repeating: key, count: keysInText)
        //get part of the key to take up the fractional area left over, defiend as extraSpaceInText
        let keyPart = (Array(key.characters)[0..<extraSpaceInText]).reduce("", {(total, next) in total + String(next)})
        //add keypart to the extened key so they are equal
        extendedKey += keyPart
        //uppercase the extended key
        extendedKey = extendedKey.uppercased()
        //convert the key to numbers
        let extendedKeyNumber = Array(extendedKey.characters).map({(next) in UInt16(toByte(c: next) + byteValue_A)})
        
        //array to hold the encrypted text
        var encryptedText = [Character]()
        //index for the extendedKeyNumner
        var keyIndex = 0
        //loop through all the characters
        for var c in unencryptedText
        {
            //convert the character to a byte
            var b = toByte(c: c)
            
            //if c is an uppercase letter
            if Global.uppercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_A) + extendedKeyNumber[keyIndex]) % 26
                b += byteValue_A
            }
            //if c is a lowercase letter
            else if Global.lowercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_a) + extendedKeyNumber[keyIndex]) % 26
                b += byteValue_a
            }
            //otherwise dont encrypt
            
            //convert the shifted byte to character
            c = toCharacter(b: b)
            //add the encrypted character to the array of ecncrypted text
            encryptedText.append(c)
            keyIndex += 1
        }
        //convert the encrypted array to a string
        let encryptedString = String(encryptedText)
        //return the ecrypted text
        return encryptedString

    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        //get a array of all of the characters
        let encryptedText = Array(toBeDecrypted.characters)
        
        //synthses the key, repeat it until run out of chars in unencryted
        //if the key is blank, then simply return the text to be encrypted so no divide by zero results
        if key.isEmpty
        {
            return toBeDecrypted
        }
        //num of keys that will fit in the text
        let keysInText = Int(encryptedText.count / key.characters.count)
        //get remainder of space in text that a whole key phrase will jot fit in
        let extraSpaceInText = Int(encryptedText.count % key.characters.count)
        //extended key, not includogn the extra space yet
        var extendedKey = String(repeating: key, count: keysInText)
        //get part of the key to take up the fractional area left over, defiend as extraSpaceInText
        let keyPart = (Array(key.characters)[0..<extraSpaceInText]).reduce("", {(total, next) in total + String(next)})
        //add keypart to the extened key so they are equal
        extendedKey += keyPart
        //uppercase the extended key
        extendedKey = extendedKey.uppercased()
        //convert the key to numbers
        let extendedKeyNumber = Array(extendedKey.characters).map({(next) in UInt16(toByte(c: next) + byteValue_A)})
        
        //array to hold the unencrypted text
        var unencryptedText = [Character]()
        //index for the extendedKeyNumner
        var keyIndex = 0
        //loop through all the characters
        for var c in encryptedText
        {
            //convert the character to a byte
            var b = toByte(c: c)
            
            //if c is an uppercase letter
            if Global.uppercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_A) - extendedKeyNumber[keyIndex]) % 26
                b += byteValue_A
            }
                //if c is a lowercase letter
            else if Global.lowercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_a) - extendedKeyNumber[keyIndex]) % 26
                b += byteValue_a
            }
            //otherwise dont decrypt
            
            //convert the shifted byte to character
            c = toCharacter(b: b)
            //add the unencrypted character to the array of unecncrypted text
            unencryptedText.append(c)
            keyIndex += 1
        }
        //convert the unencrypted array to a string
        let unencryptedString = String(unencryptedText)
        //return the unecrypted text
        return unencryptedString

    }
}
