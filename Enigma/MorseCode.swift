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
    
    //custom class to hold a letter and its corresponding morse value
    class MorseCharacter {
        //letter value
        var character = ""
        //morse value
        var morse = ""
        //init values
        init(character: String, morse: String) {
            self.character = character
            self.morse = morse
        }
    }
    
    //array that has the entire morse alphabet
    let morseCode = [MorseCharacter(character: "a", morse: ".-"),
                     MorseCharacter(character: "b", morse: "-..."),
                     MorseCharacter(character: "c", morse: "-.-."),
                     MorseCharacter(character: "d", morse: "-.."),
                     MorseCharacter(character: "e", morse: "."),
                     MorseCharacter(character: "f", morse: "..-."),
                     MorseCharacter(character: "g", morse: "--."),
                     MorseCharacter(character: "h", morse: "...."),
                     MorseCharacter(character: "i", morse: ".."),
                     MorseCharacter(character: "j", morse: ".---"),
                     MorseCharacter(character: "k", morse: "-.-"),
                     MorseCharacter(character: "l", morse: ".-.."),
                     MorseCharacter(character: "m", morse: "--"),
                     MorseCharacter(character: "n", morse: "-."),
                     MorseCharacter(character: "o", morse: "---"),
                     MorseCharacter(character: "p", morse: ".--."),
                     MorseCharacter(character: "q", morse: "--.-"),
                     MorseCharacter(character: "r", morse: ".-.-"),
                     MorseCharacter(character: "s", morse: "..."),
                     MorseCharacter(character: "t", morse: "-"),
                     MorseCharacter(character: "u", morse: "..-"),
                     MorseCharacter(character: "v", morse: "...-"),
                     MorseCharacter(character: "w", morse: ".--"),
                     MorseCharacter(character: "x", morse: "-..-"),
                     MorseCharacter(character: "y", morse: "-.--"),
                     MorseCharacter(character: "z", morse: "--.."),
                     MorseCharacter(character: "1", morse: ".----"),
                     MorseCharacter(character: "2", morse: "..---"),
                     MorseCharacter(character: "3", morse: "...--"),
                     MorseCharacter(character: "4", morse: "....-"),
                     MorseCharacter(character: "5", morse: "....."),
                     MorseCharacter(character: "6", morse: "-...."),
                     MorseCharacter(character: "7", morse: "--..."),
                     MorseCharacter(character: "8", morse: "---.."),
                     MorseCharacter(character: "9", morse: "----."),
                     MorseCharacter(character: "0", morse: "-----")]

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
            //additonal space for word is put in inside of stringFromArray
            
            //add the word to the word array
            morse.append(morseWord)
        }
        //check if its ok to do finalWord removal, if word count = 0, return empty string, otherwise do nothing
        if morse.count == 0
        {
            return ""
        }
        //remove trailing two spaces from end of last word
        //get final word
        let finalWord = morse[morse.count - 1]
        //remove the final word from the array of words
        morse.remove(at: morse.count - 1)
        
        //var to hold word with no trailing whitespace
        var finalWordNoWhiteSpace = finalWord
        //if there is trailing whitespace
        if finalWord.substring(from: finalWord.endIndex) == "  "
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
        let morseStringForm = stringFromArrayRemoveTrailer(array: morse)
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
            //add word to englishText
            englishText.append(englishWord)
        }
        //convert the english words array to a string
        let englishStringForm = stringFromArray(array: englishText)
        //return the english
        return englishStringForm
    }
    //convert character to morse code chararcter, return string value
    func convertToMorse(c: String) -> String {
        //variable to hold morse code
        var morseCodeChar = ""
        //loop through morseCode index
        morseLoop: for letterFromArray in morseCode
        {
            //if the letter is the same as the character
            if letterFromArray.character == c
            {
                //set the morse value of the letter
                morseCodeChar = letterFromArray.morse
                //break the loop
                break morseLoop
            }
        }
        //return morse code
        return morseCodeChar
    }
    //convert morse code character to englih chararcter, return string value
    func convertToEnglish(m: String) -> String {
        //variable to hold english character
        var englishChar = ""
        //loop through morseCode index
        morseLoop: for letterFromArray in morseCode
        {
            //if the letter is the same as the morse code
            if letterFromArray.morse == m
            {
                //set the character value of the letter
                englishChar = letterFromArray.character
                //break the loop
                break morseLoop
            }
        }
        //return character
        return englishChar
    }

}
