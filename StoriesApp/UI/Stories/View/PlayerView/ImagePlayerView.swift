//
//  ImagePlayerView.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

final class ImagePlayerView: UIView {
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func changeImage(_ image: UIImage?) {
        UIView.transition(with: imageView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
        })
    }
}

private extension ImagePlayerView {
    func setup() {
        imageView.activateAnchors()
        addSubview(imageView)
        imageView
            .topAnchor(to: topAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .bottomAnchor(to: bottomAnchor)
    }
}
