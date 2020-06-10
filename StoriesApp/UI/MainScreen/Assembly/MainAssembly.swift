//
//  MainAssembly.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

protocol MainAssemble: MainPresenterOutput {}

final class MainAssembly {
    static func assembly(with output: MainPresenterOutput) {
        let mainServices = MainServices(storiesService: .init())
        let presenter = MainPresenter(with: mainServices)
        presenter.output = output
        output.presenter = presenter
    }
}

