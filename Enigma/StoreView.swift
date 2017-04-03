//
//  StoreView.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/15/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit


//inapp purchases
//shared secret from itunes connect
var sharedSecret = "c75a530619e54b889c39ebe5d5c3a105"
//bundle id
let bundleID = "com.RabinApps.EnigmaMessageEncryption"

//enum for all inapp purchase registered in itunesconnect
enum RegisteredPurchases: Int, CustomStringConvertible {
    
    case XORCipher
    
    //string versions of the types
    var description: String {
        let names = ["XORCipher"]
        return names[self.rawValue]
    }
    static let allTypes = [XORCipher]
}

//class for detremining that we have a internet connection
class NetworkActivityIndicatorManager {
    
    //will increase if the internet connection is good
    //will decrease if the internet connection is bad
    private static var loadingCount = 0
    
    //the network operation is beginign
    class func networkOperationStarted() {
        
        //if the loadingCount is 0, show the user we are doing a job with activity indicator
        if loadingCount == 0
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        //increment the loading count
        loadingCount += 1
    }
    //the network operation is done
    class func networkOperationFinished() {
        
        //if the loading count is greater than 0, decrement the loadingCount
        if loadingCount > 0
        {
            loadingCount -= 1
        }
        
        //if the loading count is  0, the job is done so hide the indicator
        if loadingCount == 0
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}

//store view to purchase new encryptions
class StoreView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var tableView: UITableView!
    var contentView: UIView!
    
    //the presenting view contorller that contains this view
    var presentingVC: UIViewController?
    
    
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
        
        //purchasd the inapp purchase
        purchaseProduct(.XORCipher)
        
        
        //add encryptionTapped to users encryptions
        UserData.sharedInstance.addNewAvailableEncryption(encryptionTapped)
        
        //update the stores local copy of the availle encryptions
        generateEncryptionsToBeDisplayed()
        //reload the table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    //inapp purchases
    //get info for purchase
    func getProductInfo(_ purchase: RegisteredPurchases) {
        //start network activity
        NetworkActivityIndicatorManager.networkOperationStarted()
        //get products info, this is the bundleID with the purchase descriptio added to it
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.description], completion: { result in
            //when its done, the network actvivty is over
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            //show alert
            self.presentingVC?.present(self.alert(withRetrieveResult: result), animated: true, completion: nil)
        })
    }
    //purchase a product
    func purchaseProduct(_ purchase: RegisteredPurchases) {
        //start network activity
        NetworkActivityIndicatorManager.networkOperationStarted()
        //purchase the product
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.description, completion: { result in
            //when its done, the network actvivty is over
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            print(result)
            
            //if succesful and its the result
            if case .success(let product) = result {
                
                //TODO: Add code to add encryption to list, possible completion
                
                //if product needs to finish
                if product.needsFinishTransaction {
                    //finish transaction
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                print(result)
                //show alert
                self.presentingVC?.present(self.alert(withPurchaseResult: result), animated: true, completion: nil)
            }
            
        })
    }
    //restore all purchases
    func restorePurchases() {
        //start network activity
        NetworkActivityIndicatorManager.networkOperationStarted()
        //restore purchases
        SwiftyStoreKit.restorePurchases(atomically: true, completion: { result in
            //when its done, the network actvivty is over
            NetworkActivityIndicatorManager.networkOperationFinished()
        
            //get each product that was restored
            for product in result.restoredProducts {
                //if the transaction is not done, finish it
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            
            //show alert
            self.presentingVC?.present(self.alert(withRestoreResut: result), animated: true, completion: nil)
        })
    }
    //verify that a receipt is valid
    func verifyReceipt() {
        //start network activity
        NetworkActivityIndicatorManager.networkOperationStarted()
        //verify recipt, password is the sharedSecret
        SwiftyStoreKit.verifyReceipt(using: AppleReceiptValidator(service: .production), password: sharedSecret, completion: { result in
            //when its done, the network actvivty is over
            NetworkActivityIndicatorManager.networkOperationFinished()
        
            //show alert
            self.presentingVC?.present(self.alert(withVerifyReceiptResult: result), animated: true, completion: nil)
            
            //if there is an error
            if case .error(let error) = result {
                //if there is no receipt
                if case .noReceiptData = error {
                    //refresh the receipt
                    self.refreshReceipt()
                }
            }
            
        })
    }
    //verify that a purchase is valid
    func verifyPurchase(product: RegisteredPurchases) {
        //start network activity
        NetworkActivityIndicatorManager.networkOperationStarted()
        //verify purchase, password is the sharedSecret
        SwiftyStoreKit.verifyReceipt(using: AppleReceiptValidator(service: .production),password: sharedSecret, completion: { result in
            //when its done, the network actvivty is over
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            //switch for different things that could have happened
            switch result {
            //if succseful
            case .success(let receipt):
                //verify purchase
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: bundleID + "." + product.description, inReceipt: receipt)
                //show alert
                self.presentingVC?.present(self.alert(withVerifyProductResult: purchaseResult), animated: true, completion: nil)
                break
            //if unsuccseful
            case .error(let error):
                //show alert
                self.presentingVC?.present(self.alert(withVerifyReceiptResult: result), animated: true, completion: nil)
                //if no receipt, make one
                if case .noReceiptData = error {
                    self.refreshReceipt()
                    
                }
                break
            }
        })
    }
    //refresh the receipt
    func refreshReceipt() {
        //refresh the recipt
        SwiftyStoreKit.refreshReceipt(completion: { result in
            
            //show alert
            self.presentingVC?.present(self.alert(withRefreshReceiptResult: result), animated: true, completion: nil)
        })
    }
    
    
    //FIXME: will fix this with own custom alerts later
    //alerts
    //show simple message alert
    func alert(withTitle title: String, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            return alert
    }
    //show information about product
    func alert(withRetrieveResult result: RetrieveResults) -> UIAlertController {
        //if result has a prouct
        if let product = result.retrievedProducts.first {
            //return alert with information
            return alert(withTitle: product.localizedTitle, message: product.localizedDescription + "-" + product.localizedPrice!)
        }
        //get invalid product from result
        else if let invalidProduct = result.invalidProductIDs.first {
            //retunr alert with error message
            return alert(withTitle: "Could not find due to invalid ID", message: "Invalid product ID " + invalidProduct)
        }
        //otherwise unknown error
        else {
            //retunr alert with error message
            return alert(withTitle: "Unknown Error", message: nil)
        }
    }
    //show information about purchasing
    func alert(withPurchaseResult result: PurchaseResult) -> UIAlertController {
        
        //switch for different things that could have happened
        switch result {
            //if succseful
            case .success(let product):
            return alert(withTitle: "Thank You", message: "You have succsefully purchased " + product.productId)
            //if unsuccseful
            case .error(let error):
                //TODO: Be more descriptive of the errors, look at video 42:00
                return alert(withTitle: "Error", message: "\(error)")
        }
    }
    //show information about restoring purchases
    func alert(withRestoreResut result: RestoreResults) -> UIAlertController {
        
        //if the producst brought back fail
        if result.restoreFailedProducts.count > 0 {
            //show alert
            return alert(withTitle: "Restore Failed", message: "The restored products failed")
        }
        //if there are purchases to restore
        else if result.restoredProducts.count > 0 {
            //show alert
            return alert(withTitle: "Purchases Restored", message: "Your purchases were succsefully restored")
        }
        //otherwise user hasnt bought anything
        else {
            //show alert
            return alert(withTitle: "No Purchases to restore", message: "There is no record of you having bought any purchases")
        }
    }
    
    //show information about verifying receipt
    func alert(withVerifyReceiptResult result: VerifyReceiptResult) -> UIAlertController {
        
        //switch for different things that could have happened
        switch result {
        //if succseful
        case .success(let receipt):
            return alert(withTitle: "Verified Succsefully", message: "Receipt \(receipt)")
        //if unsuccseful
        case .error(let error):
            //TODO: Be more descriptive of the errors, look at video 50:00
            return alert(withTitle: "Error", message: "\(error)")
        }
    }
    //show information about verifying purchase
    func alert(withVerifyProductResult result: VerifyPurchaseResult) -> UIAlertController {
        //switch for different things that could have happened
        switch result {
        //if purchased
        case .purchased:
            return alert(withTitle: "Product was purchased", message: nil)
        //if not purchased
        case .notPurchased:
            return alert(withTitle: "Product was not purchased", message: nil)
        }
    }
    //show information about refreshing receipt
    func alert(withRefreshReceiptResult result: RefreshReceiptResult) -> UIAlertController {
        
        //switch for different things that could have happened
        switch result {
        //if succseful
        case .success(let receipt):
            return alert(withTitle: "Receipt Refreshed", message: "Receipt \(receipt)")
        //if unsuccseful
        case .error(let error):
            return alert(withTitle: "Error", message: "\(error)")
        }
    }
}
