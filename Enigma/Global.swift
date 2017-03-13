//
//  Global.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/1/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//contains global constants
class Global {
    
    //app color theme
    static let appColorTheme = UIColor(red: 184/255, green: 254/255, blue: 158/255, alpha: 1)
    //error color
    static let errorColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    //warning color
    static let warningColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    //information color
    static let informationColor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1)
    
    //varibles for setting up view in corridinate grid
    static var xUnit = UIScreen.main.bounds.width / 20
    static var yUnit = UIScreen.main.bounds.height / 30
    
    //all of the letters
    static let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let lowercase = "abcdefghijklmnopqrstuvwxyz"
    //all of the numbers
    static let numbers = "1234567890"
    
    //define all the consonants
    static let consonants = "BbCcDdFfGgHhJjKkLlMmNnPpQqRrSsTtVvWwXxYyZz"
    //define all the vowels
    static let vowels = "AaEeIiOoUu"
    
    //enum that correlates to the segmented control
    enum SegmentedControlIndex: Int, CustomStringConvertible {
        case Current
        case Enigma
        case Store
        
        //string versions of the types
        var description: String {
            let names = ["Current", "Enigma", "Store"]
            return names[self.rawValue]
        }
        static let allTypes = [Current, Enigma, Store]
    }
    
    //types of field for which field is the current one
    enum TypesOfField: Int, CustomStringConvertible {
        case None
        case Unencrypted
        case Encrypted
        
        //string versions of the types
        var description: String {
            let names = ["", "Unencrypted", "Encrypted"]
            return names[self.rawValue]
        }
        static let allTypes = [Unencrypted, Encrypted]
    }
    
    //encryption vars
    struct EncryptionTypes {
        //enum for all types of encryptions
        enum Types: Int, CustomStringConvertible {
            case None
            
            case UnKeyed
            case Keyed
            case Poly
            case HighLevel
            case Image

            //string versions of the types
            var description: String {
                let names = ["", "UnKeyed", "Keyed", "Polyalphabetic", "High Level", "Image"]
                return names[self.rawValue]
            }
            static let allTypes = [UnKeyed, Keyed, Poly, HighLevel, Image]
        }
        //enums for all the encryptions
        enum Encryptions: Int, CustomStringConvertible {
            case None
            
            //unkeyed
            case PigLatin
            case MorseCode
            case PigPen
            case Binary
            case Octal
            case Hexadecimal
            case ROT13
            //keyed
            case Caesar
            case XOR
            case Trans
            case RailFence
            case Columnar
            
            //MARK: Possibly add double columnar cipher
            //MARK: Possinly add repeating modular arthimetic cipher
            /* NOTE From WIKIpeida: https://en.wikipedia.org/wiki/VIC_cipher#Straddling_checkerboard
 As a simple example, we will add a secret key number (say, 0452) using modular (non-carrying) arithmetic:
 
             3	1	1	3	2	1	2	7	3	1	2	2	3	6	5	5
            +0	4	5	2	0	4	5	2	0	4	5	2	0	4	5	2
            =3	5	6	5	2	5	7	9	3	5	7	4	3	0	0	7
*/
            //polyalphabetic
            case Trithemius
            case Vigenere
            //high level
            // MARK: Split high level up into something more descriptive
            case RSA
            case Rabin
            case RC4
            case DES
            case TDEA1
            case TDEA2
            case TDEA3
            case AES128
            case AES192
            case AES256
            case Skipjack
            case ChaCha20
            case Salsa20
            case Rabbit
            case Blowfish
            
            case Image

            //string versions of the encryptions
            var description: String {
                let names = ["", "Pig Latin", "Morse Code", "PigPen Cipher", "Binary", "Octal", "Hexadecimal", "ROT-13", "Caesar Cipher", "XOR Cipher", "Transposition Cipher", "Rail Fence Cipher", "Columnar Cipher", "Trithemius Cipher", "Vigenère Cipher", "RSA", "Rabin Cryptosystem", "Rivest Cipher 4", "Data Encryption Standard", "Triple Data Encryption Algorithm - 1 Key", "Triple Data Encryption Algorithm - 2 Key", "Triple Data Encryption Algorithm - 3 Key", "Advanced Encryption Standard - 128", "Advanced Encryption Standard - 192", "Advanced Encryption Standard - 256", "Skipjack", "ChaCha20", "Salsa20", "Rabbit", "Blowfish", "Image"]
                return names[self.rawValue]
            }
            static let allEncyptions = [[PigLatin, MorseCode, PigPen, Binary, Octal, Hexadecimal, ROT13], [Caesar, XOR, Trans, RailFence, Columnar], [Trithemius, Vigenere], [RSA, Rabin, RC4, DES, TDEA1, TDEA2, TDEA3, AES128, AES192, AES256, Skipjack, ChaCha20, Salsa20, Rabbit, Blowfish], [Image]]
        }
    }
}
