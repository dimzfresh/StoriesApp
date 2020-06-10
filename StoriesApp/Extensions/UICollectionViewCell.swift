//
//  UICollectionViewCell.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String { return String(describing: self.self) }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UICollectionView {
    func register<Cell>(
        cell: Cell.Type,
        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier
        ) where Cell: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func dequeue<Cell>(_ reusableCell: Cell.Type, indexPath: IndexPath) -> Cell? where Cell: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: reusableCell.identifier, for: indexPath) as? Cell
    }
}
