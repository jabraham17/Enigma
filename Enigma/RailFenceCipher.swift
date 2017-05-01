//
//  RailFenceCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/11/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a rail fence cipher
class RailFenceCipher: KeyedEncryption {
    
    /*
     Rules for a Rail Fence Cipher
     This cipher simply scrambles the text in a particular pattern
     the text is written letter by letter down 'rails', moving up when it reaches the bottom
     the text is then read rail by rail to produce the encrypted text
     the key refers to the number of rails
     */
    
    //init with encryption type, will always be RailFence
    //init inputed key value
    init(key: String) {
        super.init(encryption: .RailFence)
        self.key = key
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        //specific key for encrytpion, this is simply the key from the super class in int form
        //MARK: show view saying key out of range
        var specificKey = Int(key)
        //if its nil, set it to 0, then return the original text since no encrypting needs to be done
        if specificKey == nil {
            specificKey = 0
            return toBeEncrypted
        }
        
        //convert input string to an array of characters
        let unencryptedArray = Array(toBeEncrypted.characters)
        
        //make array of the length of the key, with arrays with the length of the text inside of it
        var fencedArray = Array<[String?]>(repeating: Array<String?>(repeating: nil, count: unencryptedArray.count), count: specificKey!)
        
        //row number
        var row = 0
        //wether the characters are making the down pattern or up pattern
        var goingDown = true
        //loop through each character and add it to the right place in the fencedArray
        for (index, element) in unencryptedArray.enumerated() {
            
            //add the charatcer at the right row and col
            fencedArray[row][index] = String(element)
            
            //if the row is the bottom row, ie (key - 1), goingDown is false
            if row == specificKey! - 1 {
                goingDown = false
            }
            //if the row is the top row, ie 0, goingDown is true
            if row == 0 {
                goingDown = true
            }
            
            //if its going down, increment, otherwise decrement
            if goingDown {
                row += 1
            }
            else {
                row -= 1
            }
        }
        
        //flattend the array
        let fencedArrayFlat = Array(fencedArray.joined())
        //convert the flattened array to text
        let encryptedText = fencedArrayFlat.reduce("", {(total, next) in
            //if the element is nil, simpky return the total with nothing added
            if next == nil {
                return total
            }
            //other wise, return the total plus the next elemnt unwarpped
            else {
                return total + next!
            }
        })
        
        return encryptedText
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        
        //specific key for decrytion, this is simply the key from the super class in int form
        var specificKey = Int(key)
        //if its nil, set it to 0, then return the original text since no decrypting needs to be done
        if specificKey == nil {
            specificKey = 0
            return toBeDecrypted
        }
        
        //convert input string to an array of characters
        let encryptedArray = Array(toBeDecrypted.characters)
        
        //make array of the length of the key, with arrays with the length of the text inside of it
        var fencedArray = Array<[String?]>(repeating: Array<String?>(repeating: nil, count: encryptedArray.count), count: specificKey!)
        
        //row number
        var row = 0
        //wether the characters are making the down pattern or up pattern
        var goingDown = true
        //loop the number of chars in and place an empty string at each place where a character will go in the fence
        for (index, _) in encryptedArray.enumerated() {
            
            //add the empty string at the right row and col
            fencedArray[row][index] = ""
            
            //if the row is the bottom row, ie (key - 1), goingDown is false
            if row == specificKey! - 1 {
                goingDown = false
            }
            //if the row is the top row, ie 0, goingDown is true
            if row == 0 {
                goingDown = true
            }
            
            //if its going down, increment, otherwise decrement
            if goingDown {
                row += 1
            }
            else {
                row -= 1
            }
        }
        
        //got through the fenced array, if the element is nil, skip it, if the element is an empty string, put the next char from the encryptedArray in
        //index for the encryptedArray
        var encryptedArrayIndex = 0
        for (arrayIndex, array) in fencedArray.enumerated() {
            for (elementIndex, element) in array.enumerated() {
                if element != nil {
                    fencedArray[arrayIndex][elementIndex] = String(encryptedArray[encryptedArrayIndex])
                    encryptedArrayIndex += 1
                }
            }
        }
        
        //now read the fenced array in its fenced order into a string, this is the decrypted text
        var decryptedText = ""
        //row number
        row = 0
        //wether the characters are making the down pattern or up pattern
        goingDown = true
        //loop the number of chars in and read the character in from the fence
        for (index, _) in encryptedArray.enumerated() {
            
            //add the charcter at the location into the decrypted text
            decryptedText.append(fencedArray[row][index]!)
            
            //if the row is the bottom row, ie (key - 1), goingDown is false
            if row == specificKey! - 1 {
                goingDown = false
            }
            //if the row is the top row, ie 0, goingDown is true
            if row == 0 {
                goingDown = true
            }
            
            //if its going down, increment, otherwise decrement
            if goingDown {
                row += 1
            }
            else {
                row -= 1
            }
        }

        
        
        return decryptedText
    }
}









/*
 for array in fencedArray {
 let split = array.reduce("", {(total, next) in
 //if the element is nil, simpky return the total with nothing added
 if next == nil {
 return total + "."
 }
 //other wise, return the total plus the next elemnt unwarpped
 else {
 return total + next!
 }
 })
 print(split)
 }
*/
