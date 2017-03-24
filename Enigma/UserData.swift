//
//  UserData.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/13/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//class to write and read user data, all data store in UserData.plist
class UserData {
    
    //instance of UserData, this is the only way the app should interact with this class
    static let sharedInstance = UserData()
    
    //UserData.plist path
    private var path: String
    //plist data stored here
    private var data: Dictionary<String, Any>
    
    //keys to refrence to items in root array
    private let LastUsedEncryption = "LastUsedEncryption"
    private let LastUsedEncryptionType = "LastUsedEncryptionType"
    private let LastUsedField = "LastUsedField"
    private let AvailableEncryptionsToUser = "AvailableEncryptionsToUser"
    
    //init
    init() {
        //init the plist path
        //get the directory path for where the plist exists
        let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        //add the plists name to the directory path, this is the plists loaction
        path = dir + "/UserData.plist"
        print(path)
        //if the plist does not exist at its path, ie the first time the app is opened, move it to its proper path
        if !FileManager.default.fileExists(atPath: path) {
            //this is the plists path in resources, cannot be written to here which is why we move it
            let pathInBundle = Bundle.main.path(forResource: "UserData", ofType: "plist")! as String
            //attempt to move plist to proper path, should work
            do {
                try FileManager.default.copyItem(atPath: pathInBundle, toPath: path)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
        //get the actual data from the plist and store it locally
        data = NSDictionary(contentsOfFile: path) as! Dictionary<String, Any>
        
    }
    //save all the data that has been edited in the local var
    func save() {
        //get a NSDictionary object from the Dictionary object
        let dataToSave = NSDictionary(dictionary: data)
        //write it to the plist file
        dataToSave.write(toFile: path, atomically: true)
    }
    //get AvailableEncryptionsToUser
    func getAvailableEncryptionsToUser() -> Dictionary<String, Bool> {
        //get the data from the plist
        let raw = data[AvailableEncryptionsToUser] as! Dictionary<String, Bool>
        //return the Dictionary
        return raw
        
    }
    //set AvailableEncryptionsToUser
    func setAvailableEncryptionsToUser(_ availableEncryptionsToUser: Dictionary<String, Bool>) {
        //set the edited dictionary to the one in the plist
        data[AvailableEncryptionsToUser] = availableEncryptionsToUser
    }
    //add a new encryption to list of avaible ones
    func addNewAvailableEncryption(_ newAvailableEncryption: Global.EncryptionTypes.Encryptions) {
        //get dict of avaible encryptions
        var available = data[AvailableEncryptionsToUser] as! Dictionary<String, Bool>
        //edit avaible dict to have new encryption
        available[newAvailableEncryption.shortName] = true
        //set the edited list back into the plist
        data[AvailableEncryptionsToUser] = available
    }
    //get LastUsedEncryption
    func getLastUsedEncryption() -> Global.EncryptionTypes.Encryptions {
        //last used encrytion as raw int value
        let raw = data[LastUsedEncryption] as! Int
        //get the enum type of the last used
        return Global.EncryptionTypes.Encryptions(rawValue: raw)!
    }
    //set LastUsedEncryption
    func setLastUsedEncryption(_ lastUsedEncryption: Global.EncryptionTypes.Encryptions) {
        //set the raw value to the dictionary
        data[LastUsedEncryption] = lastUsedEncryption.rawValue
    }
    //get LastUsedEncryptionType
    func getLastUsedEncryptionType() -> Global.EncryptionTypes.Types {
        //last used encrytion type as raw int value
        let raw = data[LastUsedEncryptionType] as! Int
        //get the enum type of the last used
        return Global.EncryptionTypes.Types(rawValue: raw)!
    }
    //set LastUsedEncryptionType
    func setLastUsedEncryptionType(_ lastUsedEncryptionType: Global.EncryptionTypes.Types) {
        //set the raw value to the dictionary
        data[LastUsedEncryptionType] = lastUsedEncryptionType.rawValue
    }
    //get LastUsedField
    func getLastUsedField() -> Global.TypesOfField {
        //last used field as raw int value
        let raw = data[LastUsedField] as! Int
        //get the enum type of the last used
        return Global.TypesOfField(rawValue: raw)!
    }
    //set LastUsedField
    func setLastUsedField(_ lastUsedField: Global.TypesOfField) {
        //set the raw value to the dictionary
        data[LastUsedField] = lastUsedField.rawValue
    }
}
