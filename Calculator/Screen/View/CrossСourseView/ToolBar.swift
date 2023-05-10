//
//  ToolBar.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class ToolBar: UIToolbar {

    var onDone: (() -> Void)?
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setToolBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setToolBar() {
        barStyle = UIBarStyle.default
        isTranslucent = true
        tintColor = .systemBlue
        sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneTapped)
        )
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        setItems([cancelButton, spaceButton, doneButton], animated: true)
        isUserInteractionEnabled = true
    }

    @objc func doneTapped() {
        onDone?()
    }

    @objc func cancelTapped() {
        onCancel?()
    }

}
