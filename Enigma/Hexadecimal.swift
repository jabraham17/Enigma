//
//  Hexadecimal.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/22/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using hexadecimal(base 8)
class Hexadecimal: UnKeyedEncryption {
    
    /*
     Rules for Hexadecimal
     turns words into base 16 numbers according to ascii
     put 1 space between letters
     */
    
    
    //init with encryption type, will always be Hexadecimal
    override init() {
        super.init(encryption: .Hexadecimal)
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) throws -> String {
        //get a array of all of the characters
        let regularText = Array(toBeEncrypted.characters)
        //array to hold the hexadecimal
        var hexaText = [String]()
        //loop through all the characters
        for c in regularText
        {
            //convert the character to a byte
            let by = toByte(c: c)
            //convert the byte to hexadecimal
            let hexa = String(by, radix: 16)
            //add the hexadecimal to the array with a space
            hexaText.append(hexa + " ")
        }
        //convert the hexadecimal array to a string
        let hexaString = stringFromArrayRemoveTrailer(array: hexaText)
        //return the hexadecimal
        return hexaString
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
            //convert hexadecimal letter to byte
            let by = UInt16(l, radix: 16)
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
