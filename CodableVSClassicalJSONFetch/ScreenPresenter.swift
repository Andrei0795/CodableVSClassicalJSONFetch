//
//  ScreenPresenter.swift
//  CodableVSClassicalJSONFetch
//
//  Created by Andrei Ionescu on 28.05.2024.
//

import UIKit
import Combine

class ScreenPresenter {
    private var cancellables = Set<AnyCancellable>()
    let networkMonitor = NetworkMonitor()
    private (set) var window: UIWindow!
    
    //Change this for demo purposes
    var useCodable = false


    init(window: UIWindow) {
        self.window = window
    }
    
    func startApp() {
        networkMonitor.hasInternetConnection.sink { [weak self] hasInternetConnection in
            self?.showFirstVC(hasInternetConnection: hasInternetConnection)
        }.store(in: &cancellables)
        networkMonitor.checkInternetConnection()
    }
    
    private func showFirstVC(hasInternetConnection: Bool) {
        DispatchQueue.main.async {
            self.window.rootViewController = self.getCorrectVC(hasInternetConnection: hasInternetConnection)
        }
    }
    
    private func getCorrectVC(hasInternetConnection: Bool) -> UIViewController {
        if useCodable {
            let loadedVC: ViewControllerCodable = loadViewController()
            let viewModel = ViewModel(hasInternetConnection: hasInternetConnection)
            loadedVC.viewModel = viewModel
            return loadedVC
        } else {
            let loadedVC: ViewControllerClassic = loadViewController()
            let viewModel = ViewModel(hasInternetConnection: hasInternetConnection)
            loadedVC.viewModel = viewModel
            return loadedVC
        }
    }
    
    func loadViewController<T: UIViewController>() -> T {
        let currentStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let loadedVC = currentStoryboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return loadedVC
        }
        fatalError("View Controller does not have the same Storyboard ID as its class name")
    }
}
