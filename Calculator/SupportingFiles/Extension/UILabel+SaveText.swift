//
//  UILabel+SaveText.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import UIKit

extension UILabel {

    var txt: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}
