//
//  Resources.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import UIKit

enum R {
    enum Colors {
        static let displayText = UIColor(named: "Redult display text")
        
        // Block clear button
        static let blockConvertButton = UIColor(named: "Block converter button")
        
        // Block numbers
        static let numberButton = UIColor(named: "Color button")
        
        // Block operations
        static let operationButton = UIColor(named: "Block operations")
        
        // PickerView
        static let pickerViewColor = UIColor(named: "Picker view")
        static let subtitleColor = UIColor(named: "Text Subtitle")
    }
    
    enum Titles {
        static let warningAlert = NSLocalizedString("warning", comment: "")
        static let massageAlert = NSLocalizedString("noData", comment: "")
    }
}
