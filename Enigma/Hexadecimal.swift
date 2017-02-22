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
    override func encrypt(_ toBeEncrypted: String) -> String {
        //get a array of all of the characters
        let regularText = Array(toBeEncrypted.characters)
        //array to hold the hexadecimal
        var hexaText = [String]()
        //loop through all the characters
        for c in regularText
        {
            //convert the character to a byte
            let by = toByte(c: c)
            print(by)
            //convert the byte to hexadecimal
            let hexa = String(by, radix: 16)
            //add the hexadecimal to the array with a space
            hexaText.append(hexa + " ")
        }
        //convert the hexadecimal array to a string
        let hexaString = stringFromArray(array: hexaText)
        //return the hexadecimal
        return hexaString
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        //split text into sperate letters
        let letters = toBeDecrypted.components(separatedBy: " ")
        //var to hold decrypted text
        var englishText = [String]()
        //loop through the words
        for l in letters
        {
            //convert hexadecimal letter to byte
            let by = UInt16(l, radix: 16)
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
    func toByte(c: Character) -> UInt16{
        //convert character to a string, then to a byte array, then grab the byte from the array
        return [UInt16](String(c).utf16)[0]
    }
    //convert a byte to a character
    func toCharacter(b: UInt16) -> Character {
        //convert byte back into a character
        return Character(UnicodeScalar(b)!)
    }
}
