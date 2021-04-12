//
//  AlertPresentable.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import UIKit

protocol AlertPresentable {
    func alertError(error: BGError, action: ((UIAlertAction) -> Swift.Void)?)
}

extension AlertPresentable where Self: UIViewController {
    func alertError(error: BGError,
                    action: ((UIAlertAction) -> Swift.Void)?) {
        let alert: UIAlertController = UIAlertController(title: "Opps!", message: error.description, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "ok", style: .default, handler: action)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
