//
//  UIViewController+Storyboard.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

extension NSObject {
    static var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIViewController {
    class func instanceController<T>(storyboard: Storyboards) -> T {
        return storyboard.instance.instantiateViewController(withIdentifier: self.nameOfClass) as! T
    }
}

extension UIViewController {
    static func initFromNib() -> Self {
        func instanceFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: self), bundle: nil)
        }
        return instanceFromNib()
    }
}
