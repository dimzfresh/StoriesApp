//
//  MainPresenter.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

final class MainPresenter {
    weak var output: MainPresenterOutput?
    
    var service: MainServicesContainer?
        
    required init(with service: MainServicesContainer) {
        self.service = service
    }
}

extension MainPresenter: MainPresenterInput {
    func load(isRefreshing: Bool) {
        makeRequests(isRefreshing: isRefreshing)
    }
}

private extension MainPresenter {
    func makeRequests(isRefreshing: Bool) {
        var stories: [StoryItem] = []
        //var feed: [Feed] = []

        let queue = DispatchQueue.global(qos: .userInteractive)
        let group = DispatchGroup()
        
        if !isRefreshing {
            output?.startLoading()
        }
        
        group.enter()
        queue.async(group: group) { [weak self] in
//            stories = []
            stories = self?.mockStories() ?? []
            group.leave()
//            self?.loadStories {
//                banners = $0
//                group.leave()
//            }
        }
        
//        group.enter()
//        queue.async(group: group) { [weak self] in
//            self?.loadFeed {
//                feed = $0
//                group.leave()
//            }
//        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                let input: SuccessInput = .init(stories: stories)
                self.output?.sendSuccess(input: input)
                self.output?.stopLoading()
            }
        }
    }
    
    func mockStories() -> [StoryItem] {
        guard let path1 = Bundle.main.path(forResource: "story_mock1", ofType: "jpg"),
            let path2 = Bundle.main.path(forResource: "story_mock2", ofType: "jpg"),
            let path3 = Bundle.main.path(forResource: "story_mock3", ofType: "jpg"),
            let path4 = Bundle.main.path(forResource: "story_mock4", ofType: "mp4"),
            // If you want to create preview image, check 'videoPreviewImage' in VidwoPlayerView
            let path4_preview = Bundle.main.path(forResource: "story_mock4_preview", ofType: "jpg")
            else {
                return []
        }
        
        let stories: [StoryItem] = [
            StoryItem(resource: URL(fileURLWithPath: path1), preview: URL(fileURLWithPath: path1), duration: 5.0, resourceType: .photo),
            StoryItem(resource: URL(fileURLWithPath: path2), preview: URL(fileURLWithPath: path2), duration: 5.0, resourceType: .photo),
            StoryItem(resource: URL(fileURLWithPath: path3), preview: URL(fileURLWithPath: path3), duration: 5.0, resourceType: .photo),
            StoryItem(resource: URL(fileURLWithPath: path4), preview: URL(fileURLWithPath: path4_preview), duration: 13.0, resourceType: .video)
        ]
        
        let isNew = stories.filter { !$0.isChecked }
        let isChecked = stories.filter { $0.isChecked }
        
        return isNew + isChecked
    }
    
        func loadStories(completion: @escaping ([StoryItem]) -> Void) {
    //        service?.bannersService.fetchFeed { [weak self] result in
    //
    //            let bann: [BannerItem] = []
    //            switch result {
    //            case .success(let model):
    //                guard let banners = model?.banners else {
    //                    completion(bann)
    //                    return
    //                }
    //                completion(banners)
    //            case .failure(let error):
    //                print(error)
    //                self?.output?.sendFail()
    //                self?.output?.showAlert(with: .serverIsUnavailable)
    //                completion(bann)
    //            }
    //        }
        }
}
