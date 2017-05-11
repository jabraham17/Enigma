//
//  KeyedEncryption.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/1/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//super class for all keyed encryptions
class KeyedEncryption {
    
    //the encryption type, will always be Keyed
    let encryptionType = Global.EncryptionTypes.Types.Keyed
    //the specific encryption the subclass will set
    var encryption = Global.EncryptionTypes.Encryptions.None
    
    //define byte value  of 'a' and 'A'
    let byteValue_A = [UInt16]("A".utf16)[0]
    let byteValue_a = [UInt16]("a".utf16)[0]
    
    //encryption key
    var key: String
    
    //init
    init() {
        self.encryption = .None
        key = ""
    }
    //init with encryption
    init(encryption: Global.EncryptionTypes.Encryptions) {
        self.encryption = encryption
        key = ""
    }
    //encrypt function, MUST BE OVERRIDEN
    func encrypt(_ toBeEncrypted: String) throws -> String {
        //tell user that this function cannot be used until overriden
        precondition(false, "Encrypt func must be overriden in a subclass")
        return ""
    }
    //decrypt function, MUST BE OVERRIDEN
    func decrypt(_ toBeDecrypted: String) throws -> String {
        //tell user that this function cannot be used until overriden
        precondition(false, "Decrypt func must be overriden in a subclass")
        return ""
    }
    //converts an array of strings into a string
    func stringFromArray(array: [String]) -> String {
        //var to hold new string
        var newString = ""
        //loop through all elements in array and add them to newString
        for str in array
        {
            //add array element to newString
            newString += str
        }
        return newString
    }
    //converts an array of strings into a string
    func stringFromArrayRemoveTrailer(array: [String]) -> String {
        //var to hold new string
        let newString = stringFromArray(array: array)
        //if newString is not empty, remove trailing whitespace
        if !newString.isEmpty
        {
            //get the final index of the string, which is the (endIndex - 1)
            let finalIndex = newString.index(before: newString.endIndex)
            //remove trailing space
            let newStringNoTrailingWhiteSpace = newString.substring(to: finalIndex)
            //return the newString with no trailing whitespace
            return newStringNoTrailingWhiteSpace
        }
            //otherwise return an empty string
        else
        {
            return ""
        }
    }
    //convert a character to a byte
    func toByte(c: Character) -> UInt16 {
        //convert character to a string, then to a byte array, then grab the byte from the array
        return [UInt16](String(c).utf16)[0]
    }
    //convert a byte to a character
    func toCharacter(b: UInt16) -> Character {
        //convert byte back into a character
        return Character(UnicodeScalar(b)!)
    }
}
