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
    //static let appColorTheme = UIColor(red: 184/255, green: 254/255, blue: 158/255, alpha: 1)
    static let appColorTheme = UIColor(red: 58/255, green: 162/255, blue: 70/255, alpha: 1)
    //error color
    static let errorColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    //warning color
    static let warningColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
    //information color
    //static let informationColor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1)
    static let informationColor = UIColor(red: 54/255, green: 99/255, blue: 134/255, alpha: 1)

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
    
    
    
    //if an encryption is avaiblibale
    static func encryptionAvailable(encryption: EncryptionTypes.Encryptions) -> Bool {
        //get the lost of available encryptions
        let availableEncryptions = UserData.sharedInstance.getAvailableEncryptionsToUser()
        
        //search dict for inputed encryption and get its value
        let index = availableEncryptions.index(forKey: encryption.shortName)
        //return its value
        return availableEncryptions.values[index!]
    }
    //make popup
    static func popup(withTitle text: String, message: String? = nil, buttons: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], presentOn container: UIViewController) {
        
        
        //create an alert with inited info
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        //add the buttons
        for button in buttons {
            alert.addAction(button)
        }
        
        container.present(alert, animated: true, completion: nil)
    }
    //make information popup
    static func information(viewShowing: Global.SegmentedControlIndex, containerView: UIViewController, animated: Bool) {
        //load vc from nib
        let nib = UINib(nibName: String(describing: InformationVC.self), bundle: Bundle(for: InformationVC.self))
        
        let information = nib.instantiate(withOwner: containerView, options: nil)[0] as! InformationVC
        
        //make presentation so popup appears over container vc
        information.modalPresentationStyle = .overCurrentContext
        information.setup(startingIndex: viewShowing)
        
        //set delaget for custom presentation
        let transDel = PopupAnimatorDelegate()
        information.transitioningDelegate = transDel
        
        //show popup
        containerView.present(information, animated: animated, completion: nil)
    }
    //make warning popup
    /*static func warning(text: String, cancelAction: (() -> Void)?, continueAction: (() -> Void)?, containerView: UIViewController, animated: Bool) {
        //load vc from nib
        let nib = UINib(nibName: String(describing: WarningVC.self), bundle: Bundle(for: WarningVC.self))
        
        let warning = nib.instantiate(withOwner: containerView, options: nil)[0] as! WarningVC
        //setup with info
        warning.setup(text: text, cancelAction: cancelAction, continueAction: continueAction)
        
        //make presentation so warning appears over container vc
        warning.modalPresentationStyle = .overFullScreen
        //set delaget for custom presentation
        let transDel = PopupAnimatorDelegate()
        warning.transitioningDelegate = transDel
        
        //show warning
        containerView.present(warning, animated: animated, completion: nil)
    }
    //make warning popup
    static func error(text: String, okAction: (() -> Void)?, containerView: UIViewController, animated: Bool) {
        //load vc from nib
        let nib = UINib(nibName: String(describing: ErrorVC.self), bundle: Bundle(for: ErrorVC.self))
        
        let error = nib.instantiate(withOwner: containerView, options: nil)[0] as! ErrorVC
        //setup with info
        error.setup(text: text, okAction: okAction)
        
        //make presentation so error appears over container vc
        error.modalPresentationStyle = .overFullScreen
        //set delaget for custom presentation
        let transDel = PopupAnimatorDelegate()
        error.transitioningDelegate = transDel
        
        //show error
        containerView.present(error, animated: animated, completion: nil)
    }*/
    
    //enum with different errors that could occur during encryption
    enum EncryptionErrors: Error {
        
        //if the user inuted an invalid key
        case InvalidKey(key: String, message: String?)
        //if the user inputed a key out of range
        case KeyOutOfRange(key: String, message: String?)
        //if the user inputed an invalid character
        case InvalidCharacter(character: String, message: String?)
        //if the user inputed invalid text
        case InvalidText(message: String?)
        
        //the difference between charscter and text is that chaarcter is a single isnatnce with a specific case, the text is if the whole thing is invalid
    }
    
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
            //FEAT: these will be added later
            //case HighLevel
            //case Image

            //string versions of the types
            var description: String {
                let names = ["", "UnKeyed", "Keyed"]//, "High Level", "Image"]
                return names[self.rawValue]
            }
            static let allTypes = [UnKeyed, Keyed]//, HighLevel, Image]
        }
        //enums for all the encryptions
        enum Encryptions: Int, CustomStringConvertible {
            case None
            
            //unkeyed
            //case PigLatin
            case MorseCode
            case PigPen
            case Binary
            case Octal
            case Hexadecimal
            case ROT13
            //keyed
            case Caesar
            case XOR
            
            case Keyword
            case RailFence
            case Columnar
            case Vigenere
            
            //FEAT: Possibly add bifid cipher
            //FEAT: Possibly add trifid cipher
            //FEAT: Fractionation ciphers
            //FEAT: Fractionation and transposition with pigpen, morsecode, polybius square, strddling checkerboard
            //FEAT: Possibly add double columnar cipher
            //FEAT: Possinly add repeating modular arthimetic cipher
            //FEAT: One time Pad
            //FEAT: Enigma Machine
            //FEAT: HILL Cipher
            //FEAT: Beaufort cipher
            //FEAT: Autokey cipher
            //FEAT: Running key cipher
            //FEAT: Playfair cipher
            //FEAT: Solitaire (cipher)
            //FEAT: Grille (cryptography)
            //FEAT: Bacon's cipher
            //FEAT: Dvorak encoding
            //FEAT: Chaocipher cipher
            //FEAT: Four-square cipher
            //FEAT: Two-square cipher
            //FEAT: Nihilist cipher
            //FEAT: Tap code
            //FEAT: Book cipher
            //FEAT: Null cipher
            //FEAT: Affine cipher
            //FEAT: other transposiiotn ciphers
            //FEAT: other subsitiution ciphers
            //FEAT: other polyalphabetc ciphers
            /* NOTE From WIKIpeida: https://en.wikipedia.org/wiki/VIC_cipher#Straddling_checkerboard
 As a simple example, we will add a secret key number (say, 0452) using modular (non-carrying) arithmetic:
 
             3	1	1	3	2	1	2	7	3	1	2	2	3	6	5	5
            +0	4	5	2	0	4	5	2	0	4	5	2	0	4	5	2
            =3	5	6	5	2	5	7	9	3	5	7	4	3	0	0	7
*/

            //high level
            // FEAT: Split high level up into something more descriptive
            //FEAT: these will be added later
            /*case RSA
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
            
            case Image*/

            init(shortName: String) {
                switch shortName {
                /*case "PigLatin":
                    self = .PigLatin
                    break*/
                case "MorseCode":
                    self = .MorseCode
                    break
                case "PigPen":
                    self = .PigPen
                    break
                case "Binary":
                    self = .Binary
                    break
                case "Octal":
                    self = .Octal
                    break
                case "Hexadecimal":
                    self = .Hexadecimal
                    break
                case "ROT13":
                    self = .ROT13
                    break
                case "Caesar":
                    self = .Caesar
                    break
                case "XOR":
                    self = .XOR
                    break
                case "Keyword":
                    self = .Keyword
                    break
                case "RailFence":
                    self = .RailFence
                    break
                case "Columnar":
                    self = .Columnar
                    break
                case "Vigenere":
                    self = .Vigenere
                    break
                default:
                    self = .None
                    break
                }
            }
            
            //string versions of the encryptions
            var description: String {
                let names = ["", /*"Pig Latin",*/ "Morse Code", "PigPen Cipher", "Binary", "Octal", "Hexadecimal", "ROT-13", "Caesar Cipher", "XOR Cipher", "Keyword Cipher", "Rail Fence Cipher", "Columnar Cipher", "Vigenère Cipher"]//, "RSA", "Rabin Cryptosystem", "Rivest Cipher 4", "Data Encryption Standard", "Triple Data Encryption Algorithm - 1 Key", "Triple Data Encryption Algorithm - 2 Key", "Triple Data Encryption Algorithm - 3 Key", "Advanced Encryption Standard - 128", "Advanced Encryption Standard - 192", "Advanced Encryption Standard - 256", "Skipjack", "ChaCha20", "Salsa20", "Rabbit", "Blowfish", "Image"]
                return names[self.rawValue]
            }
            //string shortnames for all encyrptions
            var shortName: String {
                let shortNames = ["", /*"PigLatin",*/ "MorseCode", "PigPen", "Binary", "Octal", "Hexadecimal", "ROT13", "Caesar", "XOR", "Keyword", "RailFence", "Columnar", "Vigenere"]//, "RSA", "Rabin", "RC4", "DES", "TDEA1", "TDEA2", "TDEA3", "AES128", "AES192", "AES256", "Skipjack", "ChaCha20", "Salsa20", "Rabbit", "Blowfish", "Image"]
                return shortNames[self.rawValue]
            }
            static let allEncyptions = [[/*PigLatin,*/ MorseCode, PigPen, Binary, Octal, Hexadecimal, ROT13], [Caesar, XOR, Keyword, RailFence, Columnar, Vigenere]]//, [RSA, Rabin, RC4, DES, TDEA1, TDEA2, TDEA3, AES128, AES192, AES256, Skipjack, ChaCha20, Salsa20, Rabbit, Blowfish], [Image]]
        }
    }
}
