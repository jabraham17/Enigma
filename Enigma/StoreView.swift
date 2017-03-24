//
//  StoreView.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/15/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//store view to purchase new encryptions
class StoreView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var tableView: UITableView!
    var contentView: UIView!
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup the nib
        setupNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup the nib
        setupNib()
    }
    //setup the nib
    func setupNib() {
        //get the nib as a view
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        //set the content view so that it is the same size as the view
        contentView.frame = bounds
        //setup view so that if screen is resized the view stretches with it
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(contentView)
        
        //set deleagte methods
        tableView.delegate = self
        tableView.dataSource = self
        
        //register cell for reuse
        tableView.register(UINib(nibName: "StoreCell", bundle: .main), forCellReuseIdentifier: "EncryptionStoreCell")
        //make seprator go all the way across tableview
        tableView.separatorInset = .zero
        
        //setup purchsbale encryptions
        generateEncryptionsToBeDisplayed()
    }
    //var to hold all encryptions that are avaiable for purchase
    var purchaseableEncryptions: [[Global.EncryptionTypes.Encryptions]]?
    //var to hold all encryption types that are avaiable for purchase
    var purchaseableTypes: [Global.EncryptionTypes.Types]?
    
    //get all the ecnyptions that are avaible for purchase
    func generateEncryptionsToBeDisplayed() {
        
        //get 2D array of all encryptions
        var encryptions = Global.EncryptionTypes.Encryptions.allEncyptions
        //get array of all encrytions types
        var types = Global.EncryptionTypes.Types.allTypes
        //array of the indexs of entries in encryptions and types that need to be removed
        var indexsToRemove: [Int] = []
        
        //loop through all the arrays which represent each type in allEncryptions
        for nextTypeArrayIndex in encryptions.indices {
            //get the nextTypeArray
            var nextTypeArray = encryptions[nextTypeArrayIndex]
            //filter the array for only unavaible encryptions
            nextTypeArray = nextTypeArray.filter({!Global.encryptionAvailable(encryption: $0)})
            
            //if the nextTypeArray has a count of 0, add its index to the indexsToRemove array
            if nextTypeArray.count == 0
            {
                indexsToRemove.append(nextTypeArrayIndex)
            }
            
            //add nextType array back into encryptions so changes are saved
            encryptions[nextTypeArrayIndex] = nextTypeArray
        }
        
        //filter encryptions by indexsToRemove
        //enumeted gets a set of indexs and elements, ie arrays
        //filter which ones to keep
        //map undo the enumeration and create a regular 2D array again
        encryptions = encryptions.enumerated().filter({(index, array) in !indexsToRemove.contains(index)}).map({(index, array) in array})
        
        //filter types by indexsToRemove
        //enumeted gets a set of indexs and elements, ie type
        //filter which ones to keep
        //map undo the enumeration and create a regular 2D array again
        types = types.enumerated().filter({(index, type) in !indexsToRemove.contains(index)}).map({(index, type) in type})
        
        purchaseableEncryptions = encryptions
        purchaseableTypes = types
    }
    //get all taps by user on this view
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //if the point is contained in the tableView, retunr the table view
        if tableView.frame.contains(point) {
            return tableView
        }
        //otherwise, return the contsiner
        else {
            return contentView
        }
        
    }
    //get the number of encryptions in each type
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseableEncryptions![section].count
    }
    //number of types
    func numberOfSections(in tableView: UITableView) -> Int {
        return purchaseableEncryptions!.count
    }
    //section header titles
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //make header view
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: Global.yUnit * 1.5))
        //set the color to theme color
        header.backgroundColor = Global.appColorTheme
        
        //make label
        let label = UILabel(frame: CGRect(x: header.frame.width / 4, y: 0, width: header.frame.width / 2, height: header.frame.height))
        label.textAlignment = .center
        //header is encryption type
        label.text = purchaseableTypes?[section].description
        
        //add the label to the view
        header.addSubview(label)
        
        return header
    }
    //height of header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Global.yUnit * 1.5
    }
    //create the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retreieve resuable cell with identifer
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncryptionStoreCell", for: indexPath) as! StoreCell
        
        //set the title of the cell to the encryption at the path
        cell.label.text = purchaseableEncryptions![indexPath.section][indexPath.row].description
        //set label so that it auto resizes the font if the text is too big
        cell.label.adjustsFontSizeToFitWidth = true
        
        //TODO: set the price of the cell to the encryptions price at the path
        cell.price.text = "0.00$"
        
        return cell
    }
    //when cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deselect the cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        //get the encryption that was tapped
        let encryptionTapped = purchaseableEncryptions![indexPath.section][indexPath.row]
        //TODO: Add inapp confirmation code here
        
        //add encryptionTapped to users encryptions
        UserData.sharedInstance.addNewAvailableEncryption(encryptionTapped)
        
        //update the stores local copy of the availle encryptions
        generateEncryptionsToBeDisplayed()
        //reload the table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
