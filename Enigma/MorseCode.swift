//
//  MorseCode.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 11/27/16.
//  Copyright © 2016 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text with morse code
class MorseCode: UnKeyedEncryption {
    
    /*
     Rules for Morse Code
     Each character is represented by a series of dots and dashes
     One space between each letter, two spaces between each word
     All punctuation is removed
     */
    // FIXME: Currently only removes all puncutation instead of dealing with it
    // FIXME: Make morseCode array a dictonary so that code is more effcient

    let morseCodeDict = Dictionary(dictionaryLiteral:
        ("a", ".-"),
        ("b", "-..."),
        ("c", "-.-."),
        ("d", "-.."),
        ("e", "."),
        ("f", "..-."),
        ("g", "--."),
		("h", "...."),
		("i", ".."),
		("j", ".---"),
        ("k", "-.-"),
        ("l", ".-.."),
        ("m", "--"),
        ("n", "-."),
        ("o", "---"),
        ("p", ".--."),
        ("q", "--.-"),
        ("r", ".-.-"),
        ("s", "..."),
        ("t", "-"),
        ("u", "..-"),
        ("v", "...-"),
        ("w", ".--"),
        ("x", "-..-"),
        ("y", "-.--"),
        ("z", "--.."),
        ("1", ".----"),
        ("2", "..---"),
        ("3", "...--"),
        ("4", "....-"),
        ("5", "....."),
        ("6", "-...."),
        ("7", "--..."),
        ("8", "---.."),
        ("9", "----."),
        ("0", "-----"))
    
    //init with encryption type, will always be MorseCode
    override init() {
        super.init(encryption: .MorseCode)
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        //if the input is empty return empty string
        if toBeEncrypted == ""
        {
            return ""
        }
        //convert string to all lowercase as there is no case in morse code
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
            //if its not a lowercase letter, an uppercase letter, a number, or a space, remove from array
            //otherwise do nothing
            //this uses De Morgan's Law, applying NOT to entire expression reverses everything
            //|| becomes &&, true statements become false
            if !(Global.lowercase.contains(c) || Global.uppercase.contains(c) || Global.numbers.contains(c) || " " == c)
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
        var morse = [String]()
        //loop through all the words
        for w in words
        {
            //get the characters in the word
            let charactersInWord = Array(w.characters)
            //variable to hold the word as morse code
            var morseWord = ""
            //loop through the characters in word, convert to morse, add to morseWord
            for c in charactersInWord
            {
                //convert to morse, pass as a string
                let morseChar = convertToMorse(c: String(c))
                //add morseChar to morseWord with one space after each letter
                morseWord += morseChar + " "
            }
            //add additonal space for word
            morseWord += " "
            
            //add the word to the word array
            morse.append(morseWord)
        }
        //check if its ok to do finalWord removal, if word count = 0, return empty string, otherwise do nothing
        if morse.count == 0
        {
            return ""
        }
        
        //remove trailing two spaces from end of last word
        //remove the final word, recovering the word in the process
        let finalWord = morse.remove(at: morse.count - 1)
        
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
        morse.append(finalWordNoWhiteSpace)
        
        //convert the morse words array to a string
        let morseStringForm = stringFromArray(array: morse)
        //return the morse code
        return morseStringForm
    }
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
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
                let e = convertToEnglish(m: c)
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
    //convert character to morse code chararcter, return string value
    func convertToMorse(c: String) -> String {
        //get the index of the character and return the value at that index
        let index = morseCodeDict.index(forKey: c)
        return morseCodeDict.values[index!]
    }
    //convert morse code character to englih chararcter, return string value
    func convertToEnglish(m: String) -> String {
        //search the dictinary for the first occurance of the key and return it
        return morseCodeDict.first(where: {$1 == m})!.key
    }

}
