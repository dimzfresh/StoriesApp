//
//  MainPresenterContract.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

protocol MainPresenterInput: class {
    func load(isRefreshing: Bool)
}

protocol MainPresenterOutput: PresenterOutputProtocol {
    var presenter: MainPresenterInput? { get set }

    func sendSuccess(input: SuccessInput)
    func sendFail()
}

struct SuccessInput {
    let stories: [StoryItem]
}

protocol MainServicesContainer {
    var storiesService: StoriesService { get set }
}

struct MainServices: MainServicesContainer {
    var storiesService: StoriesService
}
