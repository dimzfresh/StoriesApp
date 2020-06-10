//
//  UITableViewCell.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifier: String { return String(describing: self.self) }

    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UITableView {
    func register<Cell>(
        cell: Cell.Type,
        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier
        ) where Cell: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeue<Cell>(_ reusableCell: Cell.Type) -> Cell? where Cell: UITableViewCell {
        return dequeueReusableCell(withIdentifier: reusableCell.identifier) as? Cell
    }
}
