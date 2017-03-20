//
//  TextViewExtension.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 3/18/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//add helpful methods to UITextView
extension UITextView {
    
    //adjust the font size to fit the text view
    func adjustFontToFitSize() {
        //if the content size is smaller than the frame, incrment until they are the same or just under
        while contentSize.height < frame.size.height {
            font = UIFont.systemFont(ofSize: (font?.pointSize)! + 1)
        }
        //if the content size is bigger than the frame, decrement until they are the same or just under
        while contentSize.height > frame.size.height {
            font = UIFont.systemFont(ofSize: (font?.pointSize)! - 1)
        }
    }
}
