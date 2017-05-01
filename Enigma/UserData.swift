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
        
        //if the plist does not exist at its path, ie the first time the app is opened, move it to its proper path
        if !FileManager.default.fileExists(atPath: path) {
            //this is the plists path in resources, cannot be written to here which is why we move it
            let pathInBundle = Bundle.main.path(forResource: "UserData", ofType: "plist")! as String
            //attempt to move plist to proper path, should work
            do {
                try FileManager.default.copyItem(atPath: pathInBundle, toPath: path)
            }catch {
                print("Error occurred while copying file to document \(error)")
            }
            //get the actual data from the plist and store it locally
            data = NSDictionary(contentsOfFile: path) as! Dictionary<String, Any>
        }
        else {
            //get the one from resource
            let resourcePath = Bundle.main.path(forResource: "UserData", ofType: "plist")! as String
            var resourceDict = NSDictionary(contentsOfFile: resourcePath) as! Dictionary<String, Any>
            
            //get the one from docs
            let docsDict = NSDictionary(contentsOfFile: path) as! Dictionary<String, Any>
            
            //check if the plist in rsource and the one stored in docs are the same, if they are, no need to do anything, if they are not, then the one in the app needs to be updated
            //if they are different
            if !resourceDict.hasSameStructure(as: docsDict) {
                //copy the data from the docsDict to the resourceDict
                resourceDict.copyValues(from: docsDict)
                
                //remove the docs dict
                do {
                    try FileManager.default.removeItem(atPath: path)
                }catch {
                    print("Error occurred while removing file \(error)")
                }
                //copy the resource plist to the file, then when save is called the data will be written to the newly formatted plist
                do {
                    try FileManager.default.copyItem(atPath: resourcePath, toPath: path)
                }catch {
                    print("Error occurred while copying file to document \(error)")
                }
                //resource dict now contains all pertainet data and structrue, assign it to the data var
                data = resourceDict
            }
            //if they ae the same
            else {
                //if they are the same, no modifying needs to be done, simpky copy the data from the current file
                data = NSDictionary(contentsOfFile: path) as! Dictionary<String, Any>
            }
        }
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



extension Dictionary {
    
    //detremine if two dicts have the same structure
    func hasSameStructure(as other: Dictionary) -> Bool {
        
        //if the dicts do not conatin equl amounts of keys, return false
        if self.count != other.count {
            return false
        }
        
        //go trhough each key, if the keys match then keep going until the end or a key is found that does not match, if a key does not match then return fasle
        for (key, value) in self {
            //if the other dict does not have the same key, they do not have same struct so return false
            if !other.keys.contains(key) {
                return false
            }
            
            //if the type of the value is not the same, they do not have the swme structure so return false
            /*if type(of: value) != type(of: other[key]) {
                return false
            }*/
            
            
            //if the value is of type Dictioanry, then detremine if the value dict are the same
            if value is Dictionary || value is NSDictionary {
                //convert generic value to dictioanry
                let subDict = value as! Dictionary
                //get the other sub dict
                let otherSubDict = other[key] as! Dictionary
                
                //if they dont have the same structure, return false
                if !subDict.hasSameStructure(as: otherSubDict) {
                    return false
                }
            }
        }
        
        //if the func hasnt exited befoe this, then the stucters are the same
        return true
    }
    
    //copy values of input dict to the current one
    mutating func copyValues(from dictToCopyFrom: Dictionary) {
        
        //go through the dictToCopyFrom, for each entry determine if the key exists in the dict, if it does copy the data over, if not do nothing
        for (key, value) in dictToCopyFrom {
            //if the key is also in the dict
            if self.keys.contains(key) {
                
                //if the value is of type Dictianry, then call copyValues on the subDict
                if value is Dictionary || value is NSDictionary {
                    //convert generic value to dictioanry
                    let subDictToCopyFrom = value as! Dictionary
                    //get the sub dict
                    var subDict = self[key] as! Dictionary
                    
                    //copy the subDictToCopyFrom to the subDict
                    subDict.copyValues(from: subDictToCopyFrom)
                    
                    //set the subdict into the place in the dict for the key
                    self[key] = subDict as? Value
                }
                else {
                    //set the value from the dictToCopyFrom into the dict
                    self[key] = value
                }
            }
            //if the key is not in the dict, skip it
        }
    }
}
