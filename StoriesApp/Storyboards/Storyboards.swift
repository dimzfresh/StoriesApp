//
//  Storyboards.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

public enum Storyboards: String {
    case splash = "LaunchScreen"
    case main = "Main"
    case stories = "Home"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

