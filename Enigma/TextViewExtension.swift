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
        
        //get the width of the text view
        let width = frame.size.width
        //get the ideal size based on the current font size
        let idealSize = sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        
        //if the ideal size is greater than the current size, decrease the font size until it fits in the ideal size
        if idealSize.height > frame.size.height {
            while sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height > frame.size.height {
                font = font!.withSize(font!.pointSize - 1)
            }
        }
            //otherwise the ideal size is less than the current size, so increase the font size until it fits in the ideal size
        else {
            while sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height < frame.size.height {
                font = font!.withSize(font!.pointSize + 1)
            }
        }
    }
}
