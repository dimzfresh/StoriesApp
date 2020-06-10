//
//  StoryPlayerViewController.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

class StoryPlayerViewController: UIViewController {
    
    @IBOutlet private weak var progressIndicatorStackView: UIStackView!
    @IBOutlet private weak var progressIndicatorStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var playerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var playerView: VideoPlayerView!
    @IBOutlet private weak var imagePlayerView: ImagePlayerView!
        
    var stories: [StoryItem] = []
    
    var currentIndex: Int = 0
    private lazy var progressViewCompletion: Completion? = { [weak self] in
        self?.playNext()
    }
    
    private let storyTransitionManager = StoryTransitionManager()
    
    private var initialTouchPoint: CGPoint = .zero
    
    override var prefersStatusBarHidden: Bool { true }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if stories.indices.contains(currentIndex) {
            currentIndex -= 1
            playNext()
            //playerView.play(with: stories[currentIndex])
            //animateCurrentIndicator()
        }
    }
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        pauseCurrentIndicator()
        close()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        share()
    }
}

private extension StoryPlayerViewController {
    func setup() {
        setupViews()
        addGestures()
        setupDelegates()
        showImage()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        playerView.playerObserverDelegate = self
        setupProgressIndicatorStackView()
    }
    
    func setupProgressIndicatorStackView() {
        progressIndicatorStackView.arrangedSubviews.forEach {
            ($0 as? ProgressView)?.onCompletion = nil
            $0.removeFromSuperview()
        }
        progressIndicatorStackView.subviews.forEach { $0.removeFromSuperview() }
        
        stories.indices.forEach { index in
            let progress = ProgressView()
            progress.duration = stories[index].duration
            progressIndicatorStackView.insertArrangedSubview(progress, at: index)
        }
        
        progressIndicatorStackView.layoutIfNeeded()
    }
    
    func layout() {
        playerView.bringSubviewToFront(imagePlayerView)
        playerView.bringSubviewToFront(closeButton)
        playerView.bringSubviewToFront(shareButton)
        playerView.bringSubviewToFront(progressIndicatorStackView)
        
        if UIDevice.current.isXScreen {
            progressIndicatorStackViewTopConstraint.constant = 44
        } else {
            progressIndicatorStackViewTopConstraint.constant = 24
        }
    }
    
    func setupDelegates() {
        playerView.playerObserverDelegate = self
    }
    
    // MARK: - Gestures
    func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned))
        view.addGestureRecognizer(pan)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        longTap.minimumPressDuration = 0.2
        longTap.delaysTouchesBegan = true
        view.addGestureRecognizer(longTap)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let width = view.bounds.width

        if location.x > width / 2 {
            playNext()
        }
        
        if location.x < width / 2 {
            playPrevious()
        }
    }
    
    @objc func longTapped(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            pauseCurrent()
            pauseCurrentIndicator()
        case .ended:
            continueCurrent()
            resumeCurrentIndicator()
        default: break
        }
    }
    
    @objc func panned(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
            pauseCurrent()
        case .changed:
            let offset = touchPoint.y - initialTouchPoint.y
            //let percent = touchPoint.y / view.frame.height
            if offset > 0 {
                playerViewTopConstraint.constant = offset
                playerViewBottomConstraint.constant = -offset
                //playerViewLeadingConstraint.constant = percent > 1 ? 16 : percent * 16
                //playerViewTrailingConstraint.constant = percent > 1 ? 16 : percent * 16
            }
        case .ended, .cancelled:
            guard touchPoint.y - initialTouchPoint.y < 120 else {
                pauseCurrent()
                close()
                return
            }
            
            self.playerViewTopConstraint.constant = 0
            self.playerViewBottomConstraint.constant = 0
            //self.playerViewLeadingConstraint.constant = 0
            //self.playerViewTrailingConstraint.constant = 0
            UIView.animate(withDuration: 0.35, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.continueCurrent()
            })
            
        default: break
        }
    }
    
    func share() {
        pauseCurrent()
        
        let content = ["Check my super app!"]
        let activityVC = UIActivityViewController(activityItems: content as [Any], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .message, .mail]
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.continueCurrent()
        }
        present(activityVC, animated: true)
    }

    func close() {
        view.backgroundColor = .clear
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Progress indicator
private extension StoryPlayerViewController {
    func animateCurrentIndicator() {
        var index = 0
                
        setupProgressIndicatorStackView()
        
        progressIndicatorStackView.arrangedSubviews.forEach {
            let progress = $0 as? ProgressView
            progress?.onCompletion = nil
            if index == currentIndex {
                progress?.onCompletion = self.progressViewCompletion
                progress?.start()
            }
            if index < currentIndex {
                progress?.fill()
            }
            if index > currentIndex {
                progress?.reset()
            }
            index += 1
        }
    }
    
    func pauseCurrentIndicator() {
        var index = 0
        progressIndicatorStackView.arrangedSubviews.forEach {
            let progress = $0 as? ProgressView
            if index == currentIndex {
                progress?.pause()
            }
            index += 1
        }
    }
    
    func resumeCurrentIndicator() {
        var index = 0
        progressIndicatorStackView.arrangedSubviews.forEach {
            let progress = $0 as? ProgressView
            if index == currentIndex {
                progress?.resume()
            }
            index += 1
        }
    }
}

// MARK: - Images
private extension StoryPlayerViewController {
    func showImage() {
        currentIndex = currentIndex < 0 ? 0 : currentIndex
        guard stories.indices.contains(currentIndex) else {
            close()
            return
        }
        
        guard let data = try? Data(contentsOf: stories[currentIndex].resource) else { return }
        let image = UIImage(data: data)
        
        imagePlayerView.changeImage(image)
        
        animateCurrentIndicator()
    }
    
    func showNextImage() {
        showImage()
    }
    
    func showPreviousImage() {
        showImage()
    }
}

// MARK: - Video player
private extension StoryPlayerViewController {
    func playNext() {
        currentIndex += 1
        
        let type = stories[currentIndex].resourceType
        switch type {
        case .photo:
            imagePlayerView.isHidden = false
            playerView.stop()
            showNextImage()
        case .video:
            imagePlayerView.isHidden = true
            play(for: currentIndex)
        }
    }
    
    func playPrevious() {
        currentIndex -= 1
        
        let type = stories[currentIndex].resourceType
        switch type {
        case .photo:
            imagePlayerView.isHidden = false
            playerView.stop()
            showPreviousImage()
        case .video:
            imagePlayerView.isHidden = true
            play(for: currentIndex)
        }
    }
    
    func pauseCurrent() {
        pauseCurrentIndicator()
        playerView.pause()
    }
    
    func continueCurrent() {
        resumeCurrentIndicator()
        playerView.play()
    }
    
    func play(for index: Int) {
        currentIndex = currentIndex < 0 ? 0 : currentIndex
        guard stories.indices.contains(currentIndex) else {
            close()
            return
        }
        
        animateCurrentIndicator()
        
        playerView.play(with: stories[currentIndex])
    }
}

extension StoryPlayerViewController: StoryPlayerObserver {
    func didStartPlaying() {
        print("Start playing")
    }
    
    func didCompletePlay() {
        print("Complete playing")
        //playNext()
    }
    
    func didTrack(progress: Float) {
        print("Progress: \(progress)")
    }
    
    func didFailed(withError error: String, for url: URL?) {
        print(error)
    }
}
