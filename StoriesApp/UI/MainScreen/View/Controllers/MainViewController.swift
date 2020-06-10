//
//  MainViewController.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 07.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    // MARK: - Presenter
    var presenter: MainPresenterInput?
        
    private var viewManager: MainViewManager?
    private let storyTransitionManager = StoryTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        presenter?.load(isRefreshing: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
    }
}

// MARK: - MainAssemble
extension MainViewController: MainAssemble  {
    func sendSuccess(input: SuccessInput) {
        viewManager?.attach(input: input)
        viewManager?.stopLoading()
    }
    
    func sendFail() {
        viewManager?.stopLoading()
    }
}

private extension MainViewController {
    func setup() {
        setupViews()
        setupViewManagers()
    }
    
    func setupViews() {
        navigationController?.delegate = storyTransitionManager
        view.backgroundColor = .white
        setupTable()
    }
    
    func setupViewManagers() {
        viewManager = MainViewManager(tableView: tableView, presenter: presenter)
        viewManager?.onSelectStoryItem = { [weak self] index, rect in
            self?.showStoryPlayer(index: index, rect: rect, stories: self?.viewManager?.stories ?? [])
        }
        viewManager?.startLoading()
    }
    
    func showStoryPlayer(index: Int, rect: CGRect, stories: [StoryItem]) {
        let storyVC = StoryPlayerViewController.initFromNib()
        storyVC.currentIndex = index
        storyVC.stories = stories
        storyVC.hidesBottomBarWhenPushed = true
        storyVC.modalPresentationStyle = .custom
        storyVC.definesPresentationContext = true
        storyVC.providesPresentationContextTransitionStyle = true
        storyVC.transitioningDelegate = storyTransitionManager
        storyTransitionManager.setStart(to: rect)
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(storyVC, animated: true)
    }
    
    func setupTable() {
        tableView.backgroundColor = .white
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 34))
        footer.backgroundColor = .white
        tableView.tableFooterView = footer
        view.addSubview(tableView)
    }
    
    func layout() {
        tableView.activateAnchors()
        tableView.topAnchor(to: view.topAnchor, constant: 24)
            .leadingAnchor(to: view.leadingAnchor)
            .trailingAnchor(to: view.trailingAnchor)
            .bottomAnchor(to: view.bottomAnchor)
    }
}

