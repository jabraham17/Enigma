//
//  ROT13.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/7/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using ROT-13
class ROT13: UnKeyedEncryption {
    
    /*
     Rules for ROT-13
     This is a Caesar Cipher where the key is always 13
     Each character is shifted by 13
     If it is applied twice, the original character is revealed
     */
    
    
    //encryption key is always 13
    let key = 13
    
    //define byte value of 'a' and 'A'
    let byteValue_A = [UInt16]("A".utf16)[0]
    let byteValue_a = [UInt16]("a".utf16)[0]
    
    //init with encryption type, will always be ROT13
    override init() {
        super.init(encryption: .ROT13)
    }
    //put ecnryptin code here
    override func encrypt(_ toBeEncrypted: String) throws -> String {
        //apply shift and return
        return shift(s: toBeEncrypted)
    }
    //put decryption code here
    override func decrypt(_ toBeDecrypted: String) throws -> String {
        //apply shift and return
        return shift(s: toBeDecrypted)
    }
    //function to apply caesar cipher with a shift of 13, since 13 is half of 16 the same method encrypts and decrypts
    func shift(s: String) -> String {
        //get a array of all of the characters
        let regularText = Array(s.characters)
        //array to hold the shifted text
        var shiftedText = [Character]()
        //loop through all the characters
        for var c in regularText
        {
            //convert the character to a byte
            var b = toByte(c: c)
            
            //if c is an uppercase letter
            if Global.uppercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_A) + UInt16(key)) % 26
                b += byteValue_A
            }
                //if c is a lowercase letter
            else if Global.lowercase.contains(String(c))
            {
                //shorten range to just 0-25, apply the shift, add modular to make it cycle
                b = ((b - byteValue_a) + UInt16(key)) % 26
                b += byteValue_a
            }
            //otherwise dont encrypt
            
            //convert the shifted byte to character
            c = toCharacter(b: b)
            //add the shifted character to the array of shifted text
            shiftedText.append(c)
        }
        //convert the encrypted array to a string
        let shiftedString = String(shiftedText)
        //return the ecrypted text
        return shiftedString
    }
}
