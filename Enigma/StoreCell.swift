//
//  StoreCell.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/21/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//class for StoreCell
class StoreCell: UITableViewCell {
    
    //encryption beng displayed in this cell
    var encryption: Global.EncryptionTypes.Encryptions?
    
    //label for encryption name
    @IBOutlet var label: UILabel!
    //label for price
    @IBOutlet var price: UILabel!
}
