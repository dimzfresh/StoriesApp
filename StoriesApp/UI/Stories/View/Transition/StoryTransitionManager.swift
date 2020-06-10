//
//  StoryTransitionManager.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

public class StoryTransitionManager: NSObject {
    let animator = StoryTransitionAnimator()
    
    func setStart(to point: CGRect) {
        animator.startingRect = point
    }
}

extension StoryTransitionManager: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.transitionMode = .present
        //animator.startingPoint = view.center
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.transitionMode = .dismiss
        //animator.startingPoint = view.center
        return animator
    }
}

extension StoryTransitionManager: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            animator.transitionMode = .present
        case .pop:
            animator.transitionMode = .pop
        default:
            animator.transitionMode = .dismiss
        }
        
        return animator
    }
}
