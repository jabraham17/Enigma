//
//  PopupAnimator.swift
//  Enigma
//
//  Created by Jacob R. Abraham on 2/24/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//custom animations for popups
class PopupAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    //aimation time
    let duration = 0.3
    //wether or not its presenting
    var presenting = true
    
    //animation time
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    //animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //get the conatiner view
        let containerView = transitionContext.containerView
        
        //get to view
        let toView = transitionContext.view(forKey: .to)!
        //set its center to the screens center
        toView.center = CGPoint(x: Global.xUnit * 10, y: Global.yUnit * 15)
        
        //add toView to container view
        containerView.addSubview(toView)
        
        //if its presenting
        if presenting
        {
            //set alpha to 0 so that iew is invisible
            toView.alpha = 0
            //animate view
            UIView.animate(withDuration: duration, animations: {
                //fade from nothng to something
                toView.alpha = 1
            },
            completion: {_ in
                //completion, complete the transituon
                transitionContext.completeTransition(true)
            })
        }
        else
        {
            //set alpha to 1 so that iew is visible
            toView.alpha = 1
            //animate view
            UIView.animate(withDuration: duration, animations: {
                //fade from full to nothing
                toView.alpha = 0
            },
            completion: {_ in
                //completion, complete the transituon
                transitionContext.completeTransition(true)
            })

        }
    }
}

