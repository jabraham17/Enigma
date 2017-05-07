//
//  PigPenCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/11/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using PigPen
class PigPenCipher: UnKeyedEncryption {
    
    /*
     Rules for a PigPen Cipher
     Each character translates to symbol in a simple subsitution cipher
     */
    
    
    //dictioanry of all pigpen character
    let pigpenDict = Dictionary(dictionaryLiteral:
        ("a", "_|"),
        ("b", "|_|"),
        ("c", "|_"),
        ("d", "]"),
        ("e", "[]"),
        ("f", "["),
        ("g", "-|"),
        ("h", "|-|"),
        ("i", "|-"),
        ("j", "._|"),
        ("k", ".|_|"),
        ("l", ".|_"),
        ("m", ".]"),
        ("n", ".[]"),
        ("o", ".["),
        ("p", ".-|"),
        ("q", ".|-|"),
        ("r", ".|-"),
        ("s", "}_{"),
        ("t", "}"),
        ("u", "{"),
        ("v", "}-{"),
        ("w", ".}_{"),
        ("x", ".}"),
        ("y", ".{"),
        ("z", ".}-{"))
    
    //init with encryption type, will always be PigPen
    override init() {
        super.init(encryption: .PigPen)
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) throws -> String {
        //if the input is empty return empty string
        if toBeEncrypted == ""
        {
            return ""
        }
        //convert string to all lowercase as there is no case in pigpen
        var english = toBeEncrypted.lowercased()
        
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
        var pigpen = [String]()
        //loop through all the words
        for w in words
        {
            //get the characters in the word
            let charactersInWord = Array(w.characters)
            //variable to hold the word as pigpen
            var pigpenWord = ""
            //loop through the characters in word, convert to pigpen, add to pigpenWord
            for c in charactersInWord
            {
                //convert to pigpen, pass as a string
                let pigpenChar = try convertToPigPen(c: String(c))
                //add pigpenChar to pigpenWord with one space after each letter
                pigpenWord += pigpenChar + " "
            }
            //add additonal space for word
            pigpenWord += " "
            
            //add the word to the word array
            pigpen.append(pigpenWord)
        }
        //check if its ok to do finalWord removal, if word count = 0, return empty string, otherwise do nothing
        if pigpen.count == 0
        {
            return ""
        }
        
        //remove trailing two spaces from end of last word
        //remove the final word, recovering the word in the process
        let finalWord = pigpen.remove(at: pigpen.count - 1)
        
        //var to hold word with no trailing whitespace
        var finalWordNoWhiteSpace = finalWord
        //if there is trailing whitespace, ie there are two spaces
        if finalWord.contains("  ")
        {
            //remove trailing whitespace from word
            //get the index of the first whitespace, which is the (endIndex - 2)
            let finalIndex = finalWord.index(finalWord.endIndex, offsetBy: -2)
            //remove the two trailing white space
            finalWordNoWhiteSpace = finalWord.substring(to: finalIndex)
        }
        //add final word with no white space to array
        pigpen.append(finalWordNoWhiteSpace)
        
        //convert the pigpen words array to a string
        let pigpenStringForm = stringFromArray(array: pigpen)
        //return the morse code
        return pigpenStringForm
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
            let characters = w.components(separatedBy: " ")
            //loop through characters
            for c in characters
            {
                //convert to english and add to english word string
                let e = try convertToEnglish(p: c)
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
    //convert character to pigpen symbol, return string value
    func convertToPigPen(c: String) throws -> String {
        //get the index of the character and return the value at that index
        let index = pigpenDict.index(forKey: c)
        //if the input is not in the dict, send warning
        if index == nil {
            throw Global.EncryptionErrors.InvalidCharacter(character: c, message: "'\(c)' is not parseable into Pig Pen")
        }
        return pigpenDict.values[index!]
    }
    //convert pigpen symbol to englih chararcter, return string value
    func convertToEnglish(p: String) throws -> String {
        //search the dictinary for the first occurance of the key and return it
        let eng = pigpenDict.first(where: {$1 == p})
        //if character does not exist, send warning
        if eng == nil {
            throw Global.EncryptionErrors.InvalidCharacter(character: p, message: "'\(p)' is not valid Pig Pen")
        }
        
        return eng!.key
    }
}
