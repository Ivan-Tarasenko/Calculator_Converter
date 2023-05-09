//
//  MultiCurrencySelectionButton.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class MultiCurrencySelectionButton: UIButton {
    
    var onActionMultiButton: (([String]) -> Void)?
    
    var viewModel: ViewModelProtocol?
    
    override public var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = ViewModel()
        backgroundColor = R.Colors.blockConvertButton
        setPopUpMenu(for: self)
    }
    
    // setting menu for pop up button
    @available(iOS 15.0, *)
    func setPopUpMenu(for button: UIButton) {
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        let itemPressed = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            if action.title != ".../₽" {
                let title = action.title.components(separatedBy: "/")
                self.onActionMultiButton?(title)
            }
        }

        var actions = [UIAction]()

        let ziroMenuItem = UIAction(title: ".../₽", state: .on, handler: itemPressed)
        actions.append(ziroMenuItem)

        viewModel?.onUpDataCurrency = { currencies in
            
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
}
