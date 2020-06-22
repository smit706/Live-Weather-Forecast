//
//  Utility.swift
//  Weather
//
//  Created by Student on 2020-04-05.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK  = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        alert.addAction(actionOK)
        present(alert, animated: true, completion: nil)
    }
}
