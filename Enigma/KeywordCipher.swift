//
//  TranspositionCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/11/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a keyword cipher
class KeywordCipher: KeyedEncryption {
    
    /*
     Rules for a Keyword Cipher
     A simple shift cipher
     A key word is appended to the beginning of the alphabet, then all duplicate letters are removed
     Then a simple substituion is applied between the regualr alphabet and the new cipher alphabet
     */
    
    
    //this dict is the alpahbet as the key, and the shifted alphabet as the value
    var alphabet = Dictionary(dictionaryLiteral:
        ("a", ""),
        ("b", ""),
        ("c", ""),
        ("d", ""),
        ("e", ""),
        ("f", ""),
        ("g", ""),
        ("h", ""),
        ("i", ""),
        ("j", ""),
        ("k", ""),
        ("l", ""),
        ("m", ""),
        ("n", ""),
        ("o", ""),
        ("p", ""),
        ("q", ""),
        ("r", ""),
        ("s", ""),
        ("t", ""),
        ("u", ""),
        ("v", ""),
        ("w", ""),
        ("x", ""),
        ("y", ""),
        ("z", ""))
    
    //override key from superclass, add a didSet which will update the shift alphabet
    override var key: String {
        //on set
        didSet {
            //get lowercase alphabet
            let lower = Global.lowercase
            //appended the lowercased key to the front of the alphabet, this will be the shifted alphabet
            //make it an array at same time
            var shifted = Array((key.lowercased() + lower).characters)
            //filter the shifted alpahbet for duplicates, remove all duplicates leaving first occurance there
            var shiftedStr = shifted.reduce("", {(total, next) in
                //convert next to a string
                let nextStr = String(next)
                //if the total already contains the next element, return empty string
                if total.contains(nextStr)
                {
                    return total
                }
                //otherwise, add the next charcter to the array
                else
                {
                    return total + nextStr
                }
            })
            //convert the string back to an array
            shifted = Array(shiftedStr.characters)
            //create new alphabet dict
            var newDict: [String : String] = [:]
            //current index for array
            var index = 0
            //loop alphabet and add it and its corresponding shifted letter to the new dict
            for nextLetter in lower.characters {
                newDict[String(nextLetter)] = String(shifted[index])
                index += 1
            }
            //set newDict to the alphabet
            alphabet = newDict
            print(alphabet)
        }
    }
    
    
    //init with encryption type, will always be Keyword
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Keyword)
        self.key = key
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) throws -> String {
        //if the input is empty return empty string
        if toBeEncrypted == ""
        {
            return ""
        }
        
        //make toBeEncrypted a var
        var english = toBeEncrypted
        
        //go through all characters and clean it of non characters
        //go in reverse order so that no index errors occur
        //run through string indexs not characters so that if it needs to be removed it it more easily done so
        //first index is last index - 1
        //var to hold current string index
        var currentStringIndex = english.index(before: english.endIndex)
        //while the current index is greater than the start index
        while currentStringIndex > english.startIndex
        {
            //get the character at current index, then convert to a string
            let c = String(english.characters[currentStringIndex])
            //if its not a lowercase letter, an uppercase letter, or a space, remove from array
            //otherwise do nothing
            //this uses De Morgan's Law, applying NOT to entire expression reverses everything
            //|| becomes &&, true statements become false
            if !(Global.lowercase.contains(c) || Global.uppercase.contains(c) || " " == c)
            {
                //remove character at index
                english.remove(at: currentStringIndex)
            }
            //advance index by one
            currentStringIndex = english.index(before: currentStringIndex)
        }
        //get a array of all of the words, using split function to split string by spaces
        let words = english.components(separatedBy: " ")
        //array to hold the encrypted text
        var transposed = [String]()
        //loop through all the words
        for w in words
        {
            //get the characters in the word
            let charactersInWord = Array(w.characters)
            //variable to hold the word as transposed
            var transposedWord = ""
            //loop through the characters in word, convert to transposed, add to ptransposedWord
            for c in charactersInWord
            {
                //convert to transposed, pass as a string
                let transposedChar = convertToTransposed(c: String(c))
                //add transposedChar to pigpenWord with one space after each letter
                transposedWord += transposedChar
            }
            //add additonal space for word
            transposedWord += " "
            
            //add the word to the word array
            transposed.append(transposedWord)
        }
        
        //convert the transposed words array to a string with no trailer
        let transposedStringForm = stringFromArrayRemoveTrailer(array: transposed)
        //return the morse code
        return transposedStringForm
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) throws -> String {
        //split text into words
        let words = toBeDecrypted.components(separatedBy: "  ")
        //var to hold decrypted text
        var englishText = [String]()
        //loop through the words
        for w in words
        {
            //var to hold english word
            var englishWord = ""
            //split the word into characters
            let characters = Array(w.characters)
            //loop through characters
            for c in characters
            {
                //convert to english and add to english word string
                let e = convertToEnglish(t: String(c))
                //add to englishWord
                englishWord.append(e)
            }
            //add space to end of english word
            englishWord += " "
            //add word to englishText
            englishText.append(englishWord)
        }
        //convert the english words array to a string
        let englishStringForm = stringFromArrayRemoveTrailer(array: englishText)
        //return the english
        return englishStringForm
    }
    //convert character to transposed character, return string value
    func convertToTransposed(c: String) -> String {
        
        //if c is uppercase, flag it and then make it lowercased
        let isUpperCase = Global.uppercase.contains(c)
        let lowerChar = c.lowercased()
        
        //get the index of the character and get the value at that index
        let index = alphabet.index(forKey: lowerChar)
        let transposed = alphabet.values[index!]
        //if c was uppercase, make transposed uppercase, then return that value
        return isUpperCase ? transposed.uppercased() : transposed
    }
    //convert transposed character to englih chararcter, return string value
    func convertToEnglish(t: String) -> String {
        
        //if t is uppercase, flag it and then make it lowercased
        let isUpperCase = Global.uppercase.contains(t)
        let lowerTrans = t.lowercased()
        
        //search the dictinary for the first occurance of the key and return it
        let english = alphabet.first(where: {$1 == lowerTrans})!.key
        
        //if t was uppercase, make english uppercase, then return that value
        return isUpperCase ? english.uppercased() : english

    }

}

