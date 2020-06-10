//
//  ProgressView.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

protocol StoryProgressProtocol {
    var onCompletion: Completion? { get set }
    var duration: Float { get set }
    var backColor: UIColor { get set }
    var lineColor: UIColor { get set }
    var lineWidth: CGFloat { get set }
    
    func fill()
    func reset()
    func start()
    func pause()
    func resume()
}

public class ProgressView: UIView {
    var duration: Float = 0
    var backColor: UIColor = UIColor.black.withAlphaComponent(0.32)
    var lineColor: UIColor = #colorLiteral(red: 0.1960784314, green: 0.262745098, blue: 0.4196078431, alpha: 1)
    var lineWidth: CGFloat = 3
    
    private var path = UIBezierPath()
    private var backLayer = CAShapeLayer()
    private var shapeLayer = CAShapeLayer()
    
    var onCompletion: Completion?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProgressView: StoryProgressProtocol {
    func start() {
        backgroundColor = backColor
        path.lineWidth = lineWidth
        path.move(to: CGPoint(x: 0, y: 1.5))
        path.addLine(to: CGPoint(x: frame.width, y: 1.5))
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.onCompletion?()
        }
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = .forwards
        animation.speed = 1
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    func pause() {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resume() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func fill() {
        backgroundColor = lineColor
        shapeLayer.removeFromSuperlayer()
        layer.removeAllAnimations()
    }
    
    func reset() {
        backgroundColor = backColor
        shapeLayer.removeFromSuperlayer()
        layer.removeAllAnimations()
    }
}

private extension ProgressView {
    func setup() {
        backgroundColor = backColor
        layer.cornerRadius = 2
        layer.masksToBounds = true
    }
}
