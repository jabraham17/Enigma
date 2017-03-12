//
//  ColumnarCipher.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/11/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//encrypts and decrypts text using a columnar cipher
class ColumnarCipher: KeyedEncryption {
    
    /*
     Rules for a Columnar Cipher
     the text is written out in a block defined by the key word
     the length of the word determines the blocks row length
     then the columns are read out in blocks based on the key word's lexigrahic ordering
     */
    
    //init with encryption type, will always be Columnar
    //init inputed key value
    init(key: String) {
        super.init(encryption: .Columnar)
        self.key = key
    }
    //MARK: Encrption Code for columnar
    //encrypt the text
    override func encrypt(_ toBeEncrypted: String) -> String {
        return toBeEncrypted
    }
    //MARK: Decrption Code for columnar
    //decrypt the text
    override func decrypt(_ toBeDecrypted: String) -> String {
        return toBeDecrypted
    }
}
