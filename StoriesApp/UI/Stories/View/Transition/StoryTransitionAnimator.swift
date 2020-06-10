//
//  StoryTransitionAnimator.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

public class StoryTransitionAnimator: NSObject {
    var startingRect: CGRect = .zero
    var presentDuration = 0.45
    var dismissDuration = 0.35

    enum TransitionMode: Int {
        case present, dismiss, pop
    }
    
    var transitionMode: TransitionMode = .present
}

extension StoryTransitionAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionMode == .present ? presentDuration : dismissDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let snapshot = fromView.snapshotView(afterScreenUpdates: false)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            containerView.addSubview(snapshot)
            fromView.removeFromSuperview()
            
            toView.frame = startingRect
            toView.layer.cornerRadius = 16
            toView.clipsToBounds = true
            toView.alpha = 0.35
            containerView.addSubview(toView)
            
            UIView.animate(withDuration: presentDuration, animations: {
                toView.frame = fromView.frame
                toView.layer.cornerRadius = 0
                toView.alpha = 1
            }, completion: { success in
                transitionContext.completeTransition(success)
            })
        } else {
            let duration = transitionDuration(using: transitionContext)
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            
            let transformY = startingRect.height / toView.frame.height
            let transformX = startingRect.width / toView.frame.width

            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(scaleX: transformX, y: transformY)
                fromView.center = .init(x: self.startingRect.origin.x + self.startingRect.width/2, y: self.startingRect.origin.y + self.startingRect.height/2)
                fromView.alpha = 0
                fromView.layer.cornerRadius = 16
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
