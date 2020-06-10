//
//  StoryItem.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import Foundation

struct StoryItem {
    let resource: URL
    let preview: URL
    let duration: Float
    let resourceType: ResourceType
    var isChecked: Bool = false
}
