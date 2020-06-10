//
//  StoriesViewManager.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

final class StoriesViewManager: NSObject {
    
    var onSelectStoryItem: ((Int, CGRect) -> Void)?
    
    private weak var collectionView: UICollectionView?
    
    var stories: [StoryItem] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    private let spacing: CGFloat = 16
    
    private var snappingDelegate: SnappingCollectionViewDelegateFlowLayout?
    
    private var orientation: UIDeviceOrientation { UIDevice.current.orientation }
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        setup()
    }
    
    private lazy var cellSize: CGSize = {
        let height = 176
        let width = 120
        return CGSize(width: width, height: height)
    }()
}

extension StoriesViewManager: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeue(StoryCollectionViewCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(story: stories[indexPath.row])
        cell.onSelectStoryItem = { [weak self] in
            let frame = cell.superview?.convert(cell.frame, to: nil) ?? .zero
            self?.onSelectStoryItem?(indexPath.row, frame)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? StoryCollectionViewCell else { return }
       
        cell.animate()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}


private extension StoriesViewManager {
    func setup() {
        setupSnappingDelegate()
        setupCollectionView()
    }
    
    func setupSnappingDelegate() {
        snappingDelegate = SnappingCollectionViewDelegateFlowLayout(spacing: spacing)
        snappingDelegate?.collectionView = collectionView
        snappingDelegate?.delegate = self
    }
    
    func setupCollectionView() {
        collectionView?.allowsSelection = true
        collectionView?.decelerationRate = .fast
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = false
        collectionView?.register(StoryCollectionViewCell.nib, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
    }
}
