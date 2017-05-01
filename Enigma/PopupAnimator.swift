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
    
    
    //blur effect for the background
    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = (UIApplication.shared.keyWindow?.bounds)!
        return blurredEffectView
    }()
    private lazy var effect:UIVisualEffect = {
        let effect = self.visualEffectView.effect
        return effect!
    }()
    
    //animation time
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    //animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //get the conatiner view
        let containerView = transitionContext.containerView
        
        //get to view
        let toView = transitionContext.view(forKey: .to)
        //set its center to the screens center
        toView?.center = CGPoint(x: Global.xUnit * 10, y: Global.yUnit * 15)
        
        //get from view
        let fromView = transitionContext.view(forKey: .from)
        
        if toView != nil {
            //add toView to container view
            containerView.addSubview(toView!)
        }
        
        //if its presenting
        if presenting
        {
            //set alpha to 0 so that iew is invisible
            toView!.alpha = 0
            
            //FIXME: fix the blur
            
            //create the visiual effeect
            self.effect = self.visualEffectView.effect!
            self.visualEffectView.effect = nil
            
            //add the visual effect
            containerView.insertSubview(self.visualEffectView, belowSubview: toView!)
            
            //animate view
            UIView.animate(withDuration: duration, animations: {
                
                //animate the visual effect
                self.visualEffectView.effect = self.effect
                //fade from nothng to something
                toView!.alpha = 1
            },
            completion: {_ in
                //completion, complete the transituon
                transitionContext.completeTransition(true)
            })
        }
        else
        {
            //set alpha to 1 so that iew is visible
            fromView!.alpha = 1
            //animate view
            UIView.animate(withDuration: duration, animations: {
                //self.visualEffectView.alpha = 0
                //self.visualEffectView.effect = nil
                //fade from full to nothing
                fromView!.alpha = 0
            },
            completion: {_ in
                //self.visualEffectView.removeFromSuperview()
                //completion, complete the transituon
                transitionContext.completeTransition(true)
            })

        }
    }
}

