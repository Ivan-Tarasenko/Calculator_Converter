//
//  BaseButton.swift
//  Calculator
//
//  Created by Иван Тарасенко on 02.11.2023.
//

import UIKit

class BaseButton: UIButton {
    
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
        layer.cornerRadius = 15
        
        setShadow()
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}
