//
//  StoriesContract.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

public enum ResourceType {
    case photo
    case video
}

public enum PlayerStatus {
    case unknown
    case playing
    case failed
    case paused
    case readyToPlay
}

protocol StoryPlayerObserver: class {
    func didStartPlaying()
    func didCompletePlay()
    func didTrack(progress: Float)
    func didFailed(withError error: String, for url: URL?)
}

protocol PlayerControls: class {
    func play(with resource: StoryItem)
    func play()
    func pause()
    func stop()
    var playerStatus: PlayerStatus { get }
}
