//
//  MainViewManager.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

final class MainViewManager: NSObject {
    
    var onSelectStoryItem: ((Int, CGRect) -> Void)?

    // MARK: - Variables
    private var tableView: UITableView?
    private var refresher: UIRefreshControl!
    private var presenter: MainPresenterInput?
    private var isRefreshing: Bool? {
        didSet {
            guard let flag = isRefreshing else { return }
            if flag {
                refresher.beginRefreshing()
            } else {
                refresher.endRefreshing()
                tableView?.reloadData()
            }
        }
    }
    
    private(set) var stories: [StoryItem] = []
    //private var feed: [Feed] = []


    // MARK: - LifeCycle
    init(tableView: UITableView?, presenter: MainPresenterInput?) {
        super.init()
        
        self.tableView = tableView
        self.presenter = presenter
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(update), for: .valueChanged)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        refresher.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        refresher.tintColor = UIColor.black.withAlphaComponent(0.7)
        
        tableView?.separatorInset = .zero
        tableView?.backgroundColor = .white
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.refreshControl = refresher
        tableView?.register(StoriesTableViewCell.nib, forCellReuseIdentifier: StoriesTableViewCell.identifier)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView?.frame.width ?? 200, height: 44))
        footerView.backgroundColor = .white
        tableView?.tableFooterView = footerView
    }
    
    func attach(input: SuccessInput) {
        self.stories = input.stories
        //self.feed = input.feed
    }
}

private extension MainViewManager {
    enum MainSections: CaseIterable {
        case feed
        case stories
    }
    
    @objc func update() {
        presenter?.load(isRefreshing: true)
    }
}

// MARK: - TableView delegate
extension MainViewManager: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = MainSections.allCases[section]
        if section == .feed {
            return 0
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()

        let section = MainSections.allCases[indexPath.section]
        if section == .stories {
            guard let cell = tableView.dequeue(StoriesTableViewCell.self) else { return defaultCell }
            cell.configure(for: stories)
            cell.onSelectStoryItem = { [weak self] index, rect in
                self?.onSelectStoryItem?(index, rect)
                //let story = self?.stories[index]
            }
            return cell
        }
          
        return defaultCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = MainSections.allCases[indexPath.section]
        switch section {
        case .feed:
            return 0
        case .stories:
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24))
        header.backgroundColor = .clear
        
        guard MainSections.allCases[section] == .stories else { return header }
        
        header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        header.backgroundColor = .white
        let title = UILabel(frame: CGRect(x: 24, y: 0, width: tableView.frame.width, height: 44))
        title.text = "Check awesome stories"
        title.textAlignment = .left
        title.font = .systemFont(ofSize: 20, weight: .medium)
        title.textColor = UIColor.black.withAlphaComponent(0.7)
        header.addSubview(title)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard MainSections.allCases[section] == .stories else { return 24 }
        return 44
    }
}

extension MainViewManager {
    func startLoading() {
        isRefreshing = true
    }
    
    func stopLoading() {
        isRefreshing = false
    }
}
