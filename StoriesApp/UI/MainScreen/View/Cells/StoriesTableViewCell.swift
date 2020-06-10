//
//  StoriesTableViewCell.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

class StoriesTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var storiesViewManager: StoriesViewManager?
    
    var onSelectStoryItem: ((Int, CGRect) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func configure(for stories: [StoryItem]) {
        storiesViewManager?.stories = stories
        storiesViewManager?.onSelectStoryItem = onSelectStoryItem
    }
}

private extension StoriesTableViewCell {
    func setup() {
        //collectionView.backgroundColor =
        selectionStyle = .none
        storiesViewManager = StoriesViewManager(collectionView: collectionView)
    }
}

