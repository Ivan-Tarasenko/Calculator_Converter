//
//  AlertService.swift
//  Calculator
//
//  Created by Иван Тарасенко on 03.11.2023.
//

import Foundation
import UIKit
 
class AlertService {
  private init () {}
 
  static let shared = AlertService()
 
    func showAlert(title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(cancel)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let viewController = windowScene.windows.first?.rootViewController {
                viewController.present(alert, animated: true, completion: nil)
            }
    }
}
