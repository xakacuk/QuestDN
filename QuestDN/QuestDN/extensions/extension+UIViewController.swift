//
//  extension+UIViewController.swift
//  QuestDN
//
//  Created by Евгений Бейнар on 11/07/2019.
//

import UIKit

extension UIViewController {
    public func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
