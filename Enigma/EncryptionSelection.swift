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
    
    //the view cotnroller showing this popup
    var sourceViewController: UIViewController?
    
    //holds EncryptionSelectionDelegate object, used to call encryptionSelected for view controller
    weak var delegate: EncryptionSelectionDelegate?
    
    //after screen has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //set custom cell for cell type
        tableView.register(UINib(nibName: "EncryptionSelectionCell", bundle: .main), forCellReuseIdentifier: "EncryptionSelectionCell")
        //make seprator go all the way across tableview
        tableView.separatorInset = .zero
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
        let label = UILabel(frame: CGRect(x: header.frame.width / 4, y: 0, width: header.frame.width / 2, height: header.frame.height))
        label.textAlignment = .center
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncryptionSelectionCell", for: indexPath) as! EncryptionSelectionCell
        
        //get the encryption
        let encryption = Global.EncryptionTypes.Encryptions.allEncyptions[indexPath.section][indexPath.row]
        
        //get the encyption name
        let name: String = encryption.description
        
        //if the next encryption is the same as the current encryption, mark it as blue
        if currentEncyption == encryption
        {
            cell.label.textColor = .blue
        }
        //otherwise, make text black
        else
        {
            cell.label.textColor = .black
        }
        //add the text to the cell
        cell.label.text = name
        
        //set textLabel so that it auto resizes the font if the text is too big
        cell.label.adjustsFontSizeToFitWidth = true
        
        
        //if the next encryption is not avaialable, mark it with a lock
        if !(Global.encryptionAvailable(encryption: encryption))
        {
            cell.locked.image = UIImage(named: "lock.png")
        }
        //otherwise, make no image
        else
        {
            cell.locked.image = nil
        }

        
        return cell
    }
    //when cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get the type encryption of the cell that was tapped
        let type = Global.EncryptionTypes.Types.allTypes[indexPath.section]
        //get the encryption of the cell that was tapped
        let encryption = Global.EncryptionTypes.Encryptions.allEncyptions[indexPath.section][indexPath.row]
        
        //if the encryption is not available, inform user of this
        if !(Global.encryptionAvailable(encryption: encryption)) {
            
            //deselect the cell
            tableView.deselectRow(at: indexPath, animated: true)
            
            //text to show user
            let text = "You do not have access to this encryption. Press continue to purchase."
            //continue action
            let continueAction = {
                //NO animateion so that it goes faster
                //dismiss the selection, open information on completion
                self.dismiss(animated: false, completion: {
                    //open informationVC with store open
                    Global.information(viewShowing: .Store, containerView: self.sourceViewController!, animated: true)
                })
            }
            Global.warning(text: text, cancelAction: nil, continueAction: continueAction, containerView: self, animated: true)
        }
        else
        {
            //dismiss the selection
            self.dismiss(animated: true, completion: {
                
                //after popup is dismissed, call the delegate
                self.delegate?.encryptionSelected(encryptionType: type, encryption: encryption)
            })
        }
    }
}
