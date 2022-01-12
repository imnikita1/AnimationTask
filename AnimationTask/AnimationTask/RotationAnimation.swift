//
//  CustomPushTrabsition.swift
//  AnimationTask
//
//  Created by CMDB-127710 on 11.01.2022.
//

import UIKit

class RotationAnimation: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    var operation: UINavigationController.Operation = .push
    weak var storedContext: UIViewControllerContextTransitioning?
    var useFrameAnimation: Bool?
    
// MARK: UIViewControllerAnimatedTransitioning methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if operation == .pop && useFrameAnimation ?? false {
            animatePopWithFrame(using: transitionContext)
            useFrameAnimation = false
            return
        }
        
        if operation == .pop {
            animatePop(using: transitionContext)
            return
        }
        
        if operation == .push {
            let toVC = transitionContext.viewController(forKey: .to) as! AnimatedViewController
            
            transitionContext.containerView.addSubview(toVC.view)
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = NSNumber(value: Double.pi * 2)
            rotation.duration = 1.5
            rotation.isCumulative = true
            rotation.delegate = self
            rotation.repeatCount = 0.5
            rotation.duration = transitionDuration(using: transitionContext)
            toVC.view.layer.add(rotation, forKey: "rotationAnimation")
            
            let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.fromValue = 0.2
            pulseAnimation.toValue = 0.8
            pulseAnimation.duration = 1.5
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.delegate = self
            pulseAnimation.repeatCount = 0.5
            toVC.view.layer.add(pulseAnimation, forKey: "pulsing")
            
        }
    }
    
// MARK: CAAnimationDelegate method
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled)
            let fromVC = context.viewController(forKey: .from) as! ViewController
            fromVC.view.layer.removeAllAnimations()

            let toVC = context.viewController(forKey: .to) as! AnimatedViewController
            toVC.view.layer.removeAllAnimations()
        }
    }
    
// MARK: Fileprivate methods
    fileprivate func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AnimatedViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ViewController
        
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        let frameOffPop = initialFrame.offsetBy(dx: initialFrame.width, dy: -755)
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = frameOffPop
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
    
    fileprivate func animatePopWithFrame(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AnimatedViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ViewController
        
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                var newFrame = fromVC.view.frame
                newFrame.origin.y -= newFrame.size.height
                fromVC.view.frame = newFrame
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
    
}

// MARK: AnimatedViewControllerDelegate
extension RotationAnimation: AnimatedViewControllerDelegate {
    func animateWithFrame() {
        useFrameAnimation = true
    }
}
