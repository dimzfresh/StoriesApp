//
//  StoryCollectionViewCell.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var storiesPreview: UIImageView!
    
    private let newStorieGradient = CAGradientLayer()
    private let innerRadius: CGFloat = 14
    private let outerRadius: CGFloat = 16
    
    private var progressLine: CAShapeLayer?
    
    var onSelectStoryItem: Completion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupNewStorieView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
}

extension StoryCollectionViewCell {
    
    func configure(story: StoryItem) {
        checkStorie(story.isChecked)

        guard let data = try? Data(contentsOf: story.preview) else {
            return
        }
        
        storiesPreview.image = UIImage(data: data)
    }
    
    func checkStorie(_ isChecked: Bool = true) {
        newStorieGradient.isHidden = isChecked
    }
    
    func animate() {
        animateProgreesLine()
        checkStorie(true)
    }
    
    func clear() {
        storiesPreview.image = nil
        layer.removeAllAnimations()
        progressLine?.removeFromSuperlayer()
        transform = .identity
    }
}

private extension StoryCollectionViewCell {
    func setup() {
        setupContentView()
    }
    
    func setupContentView() {
        storiesPreview.layer.cornerRadius = innerRadius
        storiesPreview.layer.masksToBounds = true
        contentView.layer.cornerRadius = outerRadius
        contentView.layer.masksToBounds = true
    }
    
    func setupNewStorieView() {
        newStorieGradient.frame = CGRect(origin: .zero, size: contentView.frame.size)
        newStorieGradient.drawsAsynchronously = true
        newStorieGradient.colors = [
            #colorLiteral(red: 0.6313176751, green: 0.4956816435, blue: 0.8590000272, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        ]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2.5
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        newStorieGradient.mask = shape
        newStorieGradient.masksToBounds = true
        newStorieGradient.cornerRadius = 16
        
        contentView.layer.insertSublayer(newStorieGradient, at: 0)
    }
    
    func setupWhiteView() {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: contentView.bounds.minX + 2,
                             y: contentView.bounds.minY + 2,
                             width: contentView.bounds.width - 4,
                             height: contentView.bounds.height - 4)
        layer.cornerRadius = innerRadius
        layer.masksToBounds = true
        contentView.layer.insertSublayer(layer, at: 1)
    }
            
    func animateProgreesLine() {
        layer.removeAllAnimations()

        let shapelayer = CAShapeLayer()
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.strokeColor = #colorLiteral(red: 0.8760212064, green: 0.9009236693, blue: 0.9659258723, alpha: 1).cgColor
        shapelayer.lineWidth = 2.5
        shapelayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        contentView.layer.addSublayer(shapelayer)
        progressLine = shapelayer
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        CATransaction.setCompletionBlock {
            self.onSelectStoryItem?()
        }
        
        let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
        widthAnimation.fromValue = 0.2
        widthAnimation.toValue = 3
        widthAnimation.duration = 0.4
        widthAnimation.fillMode = .forwards
        shapelayer.add(widthAnimation, forKey: "lineWidthAnimation")
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0.4
        strokeAnimation.duration = 0.4
        strokeAnimation.fillMode = .forwards
        shapelayer.add(strokeAnimation, forKey: "strokeAnimation")
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.toValue = #colorLiteral(red: 0.431372549, green: 0.5019607843, blue: 0.7058823529, alpha: 1).cgColor
        strokeColorAnimation.duration = 0.4
        strokeColorAnimation.fillMode = .forwards
        shapelayer.add(strokeColorAnimation, forKey: "strokeColorAnimation")
                
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 2,
            options: [.curveLinear, .autoreverse],
            animations: {
                self.transform = .init(scaleX: 0.985, y: 0.985)
        })
        
        CATransaction.commit()
    }
}
