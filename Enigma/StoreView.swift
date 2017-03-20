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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EncryptionStoreCell")
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
        //TODO: Needs to be the number of encrption avaible to buy
        return 7
    }
    //number of types
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Needs to be number of encryption tyoes that are available to buy
        return 4
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
        //TODO: Actual header text needed
        label.text = "HEADER"
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncryptionStoreCell", for: indexPath)
        
        return cell
    }
    //when cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: When tapped buy encryption
        print("HI")
    }
}
