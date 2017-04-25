//
//  PopupAnimatorDelegate.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/24/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//create custom animations for popups
class PopupAnimatorDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    //get controller for presentaion
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //get controller
        let controller = PopupAnimator()
        //set presenting to true
        controller.presenting = true
        return controller
    }
    //get cnyroller for dismissal
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //get controller
        let controller = PopupAnimator()
        //set presenting to true
        controller.presenting = false
        return controller
    }
}
