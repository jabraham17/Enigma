//
//  Binary.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/17/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using binary
class Binary: UnKeyedEncryption {
    
    /*
     Rules for Binary
     turns words into pure binary 1's and 0's according to ascii
     put 1 space between letters
     */
    
    
    //init with encryption type, will always be Binary
    override init() {
        super.init(encryption: .Binary)
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) throws -> String {
        //get a array of all of the characters
        let regularText = Array(toBeEncrypted.characters)
        //array to hold the binary
        var binaryText = [String]()
        //loop through all the characters
        for c in regularText
        {
            //convert the character to a byte
            let by = toByte(c: c)
            //convert the byte to binary
            let bi = String(by, radix: 2)
            //add the binary to the array with a space
            binaryText.append(bi + " ")
        }
        //convert the binary array to a string
        let binaryString = stringFromArrayRemoveTrailer(array: binaryText)
        //return the binary
        return binaryString
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) throws -> String {
        //split text into sperate letters
        let letters = toBeDecrypted.components(separatedBy: " ")
        //var to hold decrypted text
        var englishText = [String]()
        //loop through the words
        for l in letters
        {
            //convert binary letter to byte
            let by = UInt16(l, radix: 2)
            //if no byte is returned, thrwo exception
            if by == nil {
                throw Global.EncryptionErrors.InvalidCharacter(character: l, message: "'\(l)' could not be parsed into valid text")
            }
            //convert byte to character
            let c = try toCharacter(b: by!)
            //add add character to array
            englishText.append(String(c))
        }
        //convert the english words array to a string
        let englishStringForm = stringFromArray(array: englishText)
        //return the english
        return englishStringForm
    }
}
