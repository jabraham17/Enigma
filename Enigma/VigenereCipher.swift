//
//  VigenereCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 4/23/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a Vigenere Cipher
class VigenereCipher: KeyedEncryption {
    
    /*
     Rules for a Vigenere Cipher
     text is encrypted using a tabula recta
     */
    //the tabula recta, this is craeted at init
    var tabulaRecta: Dictionary<RowColPair, String>?
    
    //init with encryption type, will always be Vigenere
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Vigenere)
        self.key = key
        //make tabula recta
        tabulaRecta = createTabulaRecta()
    }
    //create the tabula recta for encryption and decryption
    func createTabulaRecta() -> Dictionary<RowColPair, String> {
        //hold the tabula recta, it will be the size of a 26x26 square
        var tabulaRecta = Dictionary<RowColPair, String>()
        //hold the alpahbet, will get shifted
        var alphabet = Array(Global.uppercase.characters)
        //go through each row and put the letter at each col into the tabulaRecta
        for row in 0...25 {
            for col in 0...25 {
                //create the row col pair
                let rowColPair = RowColPair(row: row, col: col)
                //get the letter at the col
                let letter = String(alphabet[col])
                //add a new entry the dict
                tabulaRecta[rowColPair] = letter
            }
            //shift the alphabet over one to the left
            //get the first char and remove it
            let firstChar = alphabet.removeFirst()
            //add the first char to the end of the array
            alphabet.append(firstChar)
        }
        
        return tabulaRecta
    }
    //MARK: Encrption Code for Vigenere
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        //get a array of all of the characters
        let unencryptedText = Array(toBeEncrypted.characters)
        //array to hold the encrypted text
        var encryptedText = [Character]()
        //loop through all the characters
        for var c in unencryptedText
        {
            //MARK: convert the c to a number and based on the key find its place in the tabula recta
            
            //add the encrypted character to the array of ecncrypted text
            encryptedText.append(c)
        }
        //convert the encrypted array to a string
        let encryptedString = String(encryptedText)
        //return the ecrypted text
        return encryptedString

    }
    //MARK: Decrption Code for Vigenere
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        return toBeDecrypted
    }
}
//struct to take place of a tuple as a row/col pair for defining the tabula recta
struct RowColPair {
    //row
    var row: Int
    //column
    var col: Int
    //string row
    var strRow: String
    //string col
    var strCol: String
    
    //init
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        //get string value at the row and col
        self.strRow = String(Array(Global.uppercase.characters)[row])
        self.strCol = String(Array(Global.uppercase.characters)[col])
    }
    //init
    init(row: Int, col: Int, strRow: String, strCol: String) {
        self.row = row
        self.col = col
        self.strRow = strRow
        self.strCol = strCol
    }
}
//make struct equabtable and hashable
extension RowColPair: Hashable {
    
    //detrrmine if two rowcolpairs are equal
    public static func == (one: RowColPair, two: RowColPair) -> Bool {
        //if row and col are the same, it is equal
        return one.row == two.row && one.col == two.col
    }
    //compute hashvalue for rowcolPair
    var hashValue: Int {
        //get the hashvalues and perform bitwise operation
        return row.hashValue ^ col.hashValue
    }
}
//make printable
extension RowColPair: CustomStringConvertible {
    //destriction for pair
    var description: String {
        return "Number: (\(row), \(col)) Letter: (\(strRow), \(strCol))"
    }
    
}
