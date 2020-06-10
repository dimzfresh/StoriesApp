//
//  BasePresenter.swift
//  StoriesApp
//
//  Created by Dmitrii Ziablikov on 10.06.2020.
//  Copyright © 2020 Dimzfresh. All rights reserved.
//

import UIKit

enum AlertMessage {
    case success(String)
    case error(String)
    case message(String)
    case noInternetConnection
    case serverIsUnavailable
}

protocol PresenterOutputProtocol: class {
    func startLoading()
    func stopLoading()
    
    func showAlert(with: AlertMessage)
}

extension PresenterOutputProtocol where Self: UIViewController {
    func startLoading() {
        DispatchQueue.main.async { self.start() }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { self.stop() }
    }
    
    func showAlert(with message: AlertMessage) {
        self.showAlert(with: message) {}
    }
    
    func showAlert(with message: AlertMessage, onCompletion: (() -> Void)? = nil) {
        switch message {
        case .message(let message):
            showAlert(text: message, completion: onCompletion)
        case .success(let message):
            showAlert(text: message, completion: onCompletion)
        case .error(let message):
            showAlert(text: message, completion: onCompletion)
        case .noInternetConnection:
            showAlert(text: "Отсутствует подключение к Интернету", completion: onCompletion)
        case .serverIsUnavailable:
            showAlert(text: "Ошибка. Повторите позже", completion: onCompletion)
        }
    }
}

private extension PresenterOutputProtocol where Self: UIViewController {
    func start(hideBackground: Bool = false) {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.activateAnchors()
        view.addSubview(activityView)

        activityView
            .centerXAnchor(to: view.centerXAnchor)
            .centerYAnchor(to: view.centerYAnchor)
        activityView.startAnimating()
    }
    
    func stop() {
        guard let activityView = view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView else { return }
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }

    func showAlert(text: String, button: String = "ОК", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .default, handler: { (action: UIAlertAction) in
            completion?()
        }))
    
        present(alert, animated: true)
    }
}
