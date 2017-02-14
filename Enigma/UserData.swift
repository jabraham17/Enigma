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
    static let shareInstance = UserData()
    
    //UserData.plist path
    var path: String
    
    //keys to refrence to items in root array
    let LastUsedEncryption = "LastUsedEncryption"
    let LastUsedEncryptionType = "LastUsedEncryptionType"
    let AvailableEncryptionsToUser = "AvailableEncryptionsToUser"
    
    //init
    init() {
        super.init()
        //init the plist path
        self.initPath()
    }
    
    //init the plist path
    func initPath(){
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
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }
    }
}
