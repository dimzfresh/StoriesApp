//
//  VideoPlayerView.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

final class VideoPlayerView: UIView {
    
    //MARK: - Private Vars
    private var timeObserverToken: AnyObject?
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    private var playerLayer: AVPlayerLayer?
    
    private var playerItem: AVPlayerItem? = nil {
        willSet {
            // Remove any previous KVO observer.
            guard let playerItemStatusObserver = playerItemStatusObserver else { return }
            playerItemStatusObserver.invalidate()
        }
        didSet {
            player?.replaceCurrentItem(with: playerItem)
            playerItemStatusObserver = playerItem?.observe(\.status, options: [.new, .initial], changeHandler: { [weak self] item, error in
                print(error)
                if item.status == .failed {
                    self?.activityIndicator.stopAnimating()
                    if let item = self?.player?.currentItem, let error = item.error, let url = item.asset as? AVURLAsset {
                        self?.playerObserverDelegate?.didFailed(withError: error.localizedDescription, for: url.url)
                    } else {
                        self?.playerObserverDelegate?.didFailed(withError: "Unknown error", for: nil)
                    }
                }
            })
        }
    }
    
    //MARK: - Player
    var player: AVPlayer? {
        willSet {
            // Remove any previous KVO observer.
            guard let playerTimeControlStatusObserver = playerTimeControlStatusObserver else { return }
            playerTimeControlStatusObserver.invalidate()
        }
        didSet {
            playerTimeControlStatusObserver = player?.observe(\.timeControlStatus, options: [.new, .initial], changeHandler: { [weak self] player, _ in
                guard let strongSelf = self else { return }
                if player.timeControlStatus == .playing {
                    //Started Playing
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.playerObserverDelegate?.didStartPlaying()
                } else if player.timeControlStatus == .paused {
                    // player paused
                } else {
                    //
                }
            })
        }
    }
    var error: Error? { player?.currentItem?.error }
    
    private var activityIndicator: UIActivityIndicatorView!
    
    var currentItem: AVPlayerItem? { player?.currentItem }
    
    var currentTime: Float { Float(player?.currentTime().value ?? 0) }
    
    //MARK: - Public Vars
    public weak var playerObserverDelegate: StoryPlayerObserver?
    
    //MARK:- Init
    override init(frame: CGRect) {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if #available(iOS 13.0, *) {
             activityIndicator = UIActivityIndicatorView(style: .large)
         } else {
             activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
         }
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    deinit {
        if let existingPlayer = player, existingPlayer.observationInfo != nil {
            removeObservers()
        }
    }
    
    // MARK: - Internal methods
    func setupActivityIndicator() {
        activityIndicator.alpha = 0
        activityIndicator.hidesWhenStopped = true
        //backgroundColor = .brandGrayBlue
        addSubview(activityIndicator)
        activityIndicator
            .centerXAnchor(to: centerXAnchor)
            .centerYAnchor(to: centerYAnchor)
    }
    
    func startAnimating() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.startAnimating()
    }
    
    func removeObservers() {
        cleanUpPlayerPeriodicTimeObserver()
    }
    
    func cleanUpPlayerPeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func setupPlayerPeriodicTimeObserver() {
        guard timeObserverToken == nil else { return }
        
        // Use a weak self variable to avoid a retain cycle in the block.
        timeObserverToken =
            player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: .main) { [weak self] time in
                let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
                if let currentItem = self?.player?.currentItem {
                    let totalTimeString =  String(format: "%02.2f", CMTimeGetSeconds(currentItem.asset.duration))
                    if timeString == totalTimeString {
                        self?.playerObserverDelegate?.didCompletePlay()
                    }
                }
                if let time = Float(timeString) {
                    self?.playerObserverDelegate?.didTrack(progress: time)
                }
            } as AnyObject
    }
    
    func videoPreviewImage(url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        guard let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 2, preferredTimescale: 60), actualTime: nil) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - Protocol PlayerControls
extension VideoPlayerView: PlayerControls {
    func play(items: [AVPlayerItem]) {
        let queuePlayer = AVQueuePlayer(items: items)
        
        queuePlayer.allowsExternalPlayback = true
        queuePlayer.actionAtItemEnd = .none
        player = queuePlayer
    }
    
    func play(with item: StoryItem) {
        let url = item.resource
        //guard let url = resource.url else {
            //fatalError("Unable to form URL from resource")
        //}
        
        if let existingPlayer = player {
            let asset = AVAsset(url: url)
            playerItem = AVPlayerItem(asset: asset)
            DispatchQueue.main.async { [weak self] in
                self?.player = existingPlayer
                self?.player?.replaceCurrentItem(with: self?.playerItem)
            }
        } else {
            let asset = AVAsset(url: url)
            playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            setupPlayerPeriodicTimeObserver()
            if let pLayer = playerLayer {
                pLayer.videoGravity = .resizeAspectFill
                pLayer.frame = bounds
                layer.insertSublayer(pLayer, at: 0)
            }
        }
        startAnimating()
        play()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        guard let existingPlayer = player else { return } //player was already deallocated
        
        DispatchQueue.main.async { [weak self] in
            existingPlayer.pause()
            //Remove observer if observer presents before setting player to nil
            if existingPlayer.observationInfo != nil {
                self?.removeObservers()
            }
            self?.playerItem = nil
            self?.player = nil
            self?.playerLayer?.removeFromSuperlayer()
        }
    }
    
    var playerStatus: PlayerStatus {
        switch player?.status {
        case .unknown:
            return .unknown
        case .readyToPlay:
            return .readyToPlay
        case .failed:
            return .failed
        default:
            return .unknown
        }
    }
}
