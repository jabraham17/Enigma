//
//  EncryptionSelection.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/2/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol EncryptionSelectionDelegate: class {
    //called when encryption is tapped, will be implemented in view controller acknolwding this protocol/delegate
    func encryptionSelected(encryptionType: Global.EncryptionTypes.Types, encryption: Global.EncryptionTypes.Encryptions)
}
//popover view controller to select encryption
class EncryptionSelection: UITableViewController {
    
    //the currently selected encryption
    var currentEncyption: Global.EncryptionTypes.Encryptions = Global.EncryptionTypes.Encryptions.None
    
    //holds EncryptionSelectionDelegate object, used to call encryptionSelected for view controller
    weak var delegate: EncryptionSelectionDelegate?
    
    //after screen has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //set default cell for cell type
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EncyptionSelectionCell")
        //turn off view bouncing
        tableView.bounces = false
        //turn off scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    //get the number of encryptions in each type
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.EncryptionTypes.Encryptions.allEncyptions[section].count
    }
    //number of types
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Global.EncryptionTypes.Types.allTypes.count
    }
        //section header titles
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //make header view
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: Global.yUnit * 1.5))
        //set the color to theme color
        header.backgroundColor = Global.appColorTheme
        
        //make label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: header.frame.width, height: header.frame.height))
        label.text = Global.EncryptionTypes.Types.allTypes[section].description
        
        //add the label to the view
        header.addSubview(label)
            
        return header
    }
    //height of header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Global.yUnit * 1.5
    }
    //create the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retreieve resuable cell with identifer
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncyptionSelectionCell", for: indexPath)
        
        //get the encryption
        let encryption = Global.EncryptionTypes.Encryptions.allEncyptions[indexPath.section][indexPath.row]
        
        //get the encyption name
        let name: String = encryption.description
        
        //if the next encryption is the same as the current encryption, mark it as blue
        if currentEncyption == encryption
        {
            cell.textLabel?.textColor = UIColor.blue
        }
        //otherwise, make text black
        else
        {
            cell.textLabel?.textColor = UIColor.black
        }
        //add the text to the cell
        cell.textLabel?.text = name
        
        
        return cell
    }
    //when cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get the type encryption of the cell that was tapped
        let type = Global.EncryptionTypes.Types.allTypes[indexPath.section]
        //get the encryption of the cell that was tapped
        let encryption = Global.EncryptionTypes.Encryptions.allEncyptions[indexPath.section][indexPath.row]
        
        //call the delegate
        delegate?.encryptionSelected(encryptionType: type, encryption: encryption)
        
        //dismiss the selection
        self.dismiss(animated: true, completion: nil)
    }
}
