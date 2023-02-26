//
//  SplashViewController.swift
//  MovieSearch
//
//  Created by user226229 on 26.02.2023.
//

import UIKit
import Network

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Check internet connectivity
        if !checkInternetConnectivity() {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                exit(0)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Wait for 3 seconds before presenting the main screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainScreenView") as? MainScreenController else { return }
            let navigationController = UINavigationController(rootViewController: mainViewController)
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    // Function to check internet connectivity
    func checkInternetConnectivity() -> Bool {
        let monitor = NWPathMonitor()
        var isConnected = false
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        return isConnected
    }
}
