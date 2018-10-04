//
//  Alert.swift
//  LoginTest
//
//  Created by Руслан Акберов on 04.10.2018.
//  Copyright © 2018 Ruslan Akberov. All rights reserved.
//

import UIKit

struct Alert {
    
    private static func basicAlert(title: String, message: String, on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(closeAction)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showServerErrorAlert(on viewController: UIViewController) {
        basicAlert(title: "Error", message: "Server is unavailable", on: viewController)
    }
}


