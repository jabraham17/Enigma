//
//  PigLatin.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/10/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using pig latin
class PigLatin: UnKeyedEncryption {
    
    /*
     Rules for Pig Latin
     If the word begins with a consonant, all letters before the first vowel are move to the end and "ay" is added to the end
     If the word begins with a vowel, there is no shift of characters and "way" is added to the end
     */
    
    
    //define ending of a word when it starts with a consonant
    let consonantEnding = "ay"
    //define ending of a word when it starts with a vowel
    let vowelEnding = "way"
    
    //init with encryption type, will always be PigLatin
    override init() {
        super.init(encryption: .PigLatin)
    }
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        //if the string is empty, return an empty string
        if toBeEncrypted == ""
        {
            return ""
        }
        //get a array of all of the words, using split function to split string by spaces
        let english = toBeEncrypted.components(separatedBy: " ")
        // FIXME: Need to add better filter for creating the words in the unecrypted text, currently only removes whitespace, but punctuation which will confuse encryption technique are not removed/dealt with in encryption
        
        //array to hold the pig latin
        var pigLatin = [String]()
        //loop through all the words
        for var w in english
        {
            //get the characters in the word
            var charactersInWord = Array(w.characters)
            //first letter in word
            let firstLetter = String(charactersInWord[0])
            //determine if it starts with a consonant or a vowel
            //if it starts with a consonant
            if Global.consonants.contains(firstLetter)
            {
                //var to hold the all characters up to the first vowel
                var upToFirstVowel = ""
                //var to hold the rest of the word
                var afterFirstVowel = ""
                //go through word until vowel is found
                loopInsideWord: for c in 1...charactersInWord.count
                {
                    //if its a vowel
                    if Global.vowels.contains(String(charactersInWord[c]))
                    {
                        //get index of last consonant
                        let lastConsonantIndex = c
                        //get the string index of last consonant
                        let stringIndexLastConsonant = w.index(w.startIndex, offsetBy: lastConsonantIndex)
                        //get the characters up to the first vowel
                        upToFirstVowel = w.substring(to: stringIndexLastConsonant)
                        //get the characters after the first vowel
                        afterFirstVowel = w.substring(from: stringIndexLastConsonant)
                        
                        //leave the loop
                        break loopInsideWord
                    }
                }
                //place the afterFirstVowel before upToFirstVowel, then add consonant ending
                w = afterFirstVowel + upToFirstVowel + consonantEnding
            }
                //if the word starts with a vowel
            else if Global.vowels.contains(firstLetter)
            {
                //add vowel ending
                w += vowelEnding
            }
            
            //filter out words so that if a letter is capitailzed it is the capitlaization is moved to the front and if their is a punctuation mark move it to the end
            //true if their is a capitol
            var isThereCapitol = false
            var punctuationMark = ""
            for var c in w.characters
            {
                //if the char is capitalozed, mark that there is a capitol
                if Global.uppercase.contains(String(c))
                {
                    isThereCapitol = true
                }
                //TODO: if there is punctuation, remove it and add it to the punctuation to be added at the end of the word
                
            }
            //if there was a capitol, make all letters lowercase except the first letter
            if isThereCapitol {
                //make lowercase
                w = w.lowercased()
                //make first letter lowercase
                w = w.capitalized
            }
            
            
            //add the encrypted character to the array of pig latin
            pigLatin.append(w)
        }
        //convert the pig latin array to a string
        let pigLatinStringForm = stringFromArrayRemoveTrailer(array: pigLatin)
        //return the pig latin
        return pigLatinStringForm
    }
    // TODO: Decrypt function
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        //get a array of all of the words, using split function to split string by spaces
        let pigLatin = toBeDecrypted.components(separatedBy: " ")
        // FIXME: Need to add better filter for creating the words in the unecrypted text, currently only removes whitespace, but punctuation which will confuse encryption technique are not removed/dealt with in encryption
        
        //array to hold the english
        var english = [String]()
        //loop through all the characters
        for var w in pigLatin
        {
            // FIXME: Add decryption logic
            //add the english character to the array of english
            english.append(w)
        }
        //convert the english array to a string
        let englishStringForm = stringFromArray(array: english)
        //return the english
        return englishStringForm
    }
}

