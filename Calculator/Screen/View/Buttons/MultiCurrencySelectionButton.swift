//
//  MultiCurrencySelectionButton.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class MultiCurrencySelectionButton: BaseButton {
    
    var onActionMultiButton: (([String]) -> Void)?
    var currencies: [String: Currency]?
    
    // setting menu for pop up button
    func setPopUpMenu(for button: UIButton) {
        
        guard let currencies = currencies else { return }
        
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let itemPressed = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            if action.title != ".../₽" {
                let title = action.title.components(separatedBy: "/")
                self.onActionMultiButton?(title)
            }
        }
        
        var actions = [UIAction]()
        
        let zeroMenuItem = UIAction(title: ".../₽", state: .on, handler: itemPressed)
        actions.append(zeroMenuItem)
        
        let sortCurrency = currencies.sorted(by: {$0.key > $1.key})
        
        for (key, value) in sortCurrency {
            let action = UIAction(title: "\(key)/₽", subtitle: value.name, state: .on, handler: itemPressed)
            actions.append(action)
        }
        
        button.menu = UIMenu(title: ".../₽", children: actions)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
    }
}
