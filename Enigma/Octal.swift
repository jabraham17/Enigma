//
//  Octal.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/22/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using octal(base 8)
class Octal: UnKeyedEncryption {
    
    /*
     Rules for Octal
     turns words into base 8 numbers according to ascii
     put 1 space between letters
     */
    
    
    //init with encryption type, will always be Octal
    override init() {
        super.init(encryption: .Octal)
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        //get a array of all of the characters
        let regularText = Array(toBeEncrypted.characters)
        //array to hold the octal
        var octalText = [String]()
        //loop through all the characters
        for c in regularText
        {
            //convert the character to a byte
            let by = toByte(c: c)
            print(by)
            //convert the byte to octal
            let oct = String(by, radix: 8)
            //add the octal to the array with a space
            octalText.append(oct + " ")
        }
        //convert the octal array to a string
        let octalString = stringFromArrayRemoveTrailer(array: octalText)
        //return the octal
        return octalString
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        //split text into sperate letters
        let letters = toBeDecrypted.components(separatedBy: " ")
        print(letters)
        //var to hold decrypted text
        var englishText = [String]()
        //loop through the words
        for l in letters
        {
            //convert octal letter to byte
            let by = UInt16(l, radix: 8)
            //convert byte to character
            let c = toCharacter(b: by!)
            //add add character to array
            englishText.append(String(c))
        }
        //convert the english words array to a string
        let englishStringForm = stringFromArray(array: englishText)
        //return the english
        return englishStringForm
    }
}
