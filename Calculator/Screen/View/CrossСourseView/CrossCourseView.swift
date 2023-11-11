//
//  CrossCourseView.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class CrossCourseView: UIView {
    
    var onDoneAction: (() -> Void)?
    var onCancelAction: (() -> Void)?
    
    var dataSource = PickerDataSource()
    
    var currencies: [String: Currency] = [:]

    private let stackView = UIStackView()
    private let pickerView = UIPickerView()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        configurationView()
        addConstraint()
        configurationStackView()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.pickerView.dataSource = dataSource
        self.pickerView.delegate = dataSource
        dataSource.currencies = currencies
        dataSource.title = getSortCurrencyKeys(from: currencies)
        dataSource.subtitle = getSortCurrencyName(from: currencies)
    }
    
}

// MARK: - Private extensiion
private extension CrossCourseView {
    
    func getSortCurrencyKeys(from data: [String: Currency]) -> [String] {
        let sortCurrency = data.sorted(by: {$0.key > $1.key})
        var keys = [String]()
        for (key, _) in sortCurrency {
            keys.append(key)
        }
        return keys
    }
    
    func getSortCurrencyName(from data: [String: Currency]) -> [String] {
        let sortCurrency = data.sorted(by: {$0.key > $1.key})
        var names = [String]()
        for (_, value) in sortCurrency {
            names.append(value.name)
        }
        return names
    }
    
    func configurationView() {
        pickerView.backgroundColor = UIColor(resource: .pickerView)
        addSubview(pickerView)
        addSubview(stackView)
    }
    
    func configurationStackView() {
        stackView.backgroundColor = UIColor(resource: .pickerView)
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(doneButton)
    }
    
    func addConstraint() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.topAnchor.constraint(equalTo: stackView.topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.heightAnchor.constraint(equalToConstant: 44),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    func addTarget() {
        doneButton.addTarget(self, action: #selector(doneButtonPress), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonPress), for: .touchUpInside)
    }
}

@objc extension CrossCourseView {
    func doneButtonPress() {
        onDoneAction?()
    }
    
    func cancelButtonPress() {
        onCancelAction?()
    }
}
