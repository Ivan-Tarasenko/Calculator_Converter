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
    
    private let stackView = UIStackView()
    
    private let pickerView = UIPickerView()
    
    private let viewModel: ViewModelProtocol
    
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
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configurationView()
        addConstraint()
        configurationStackView()
        addTarget()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private extensiion
private extension CrossCourseView {
    func configurationView() {
        pickerView.backgroundColor = R.Colors.pickerViewColor
        addSubview(pickerView)
        addSubview(stackView)
    }
    
    func configurationStackView() {
        stackView.backgroundColor = R.Colors.pickerViewColor
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(doneButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addConstraint() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func bind() {
        viewModel.onUpDataCurrency = { [weak self, dataSource] data in
            guard let self = self else { return }
            dataSource.currencies = data
            self.pickerView.dataSource = dataSource
            self.pickerView.delegate = dataSource
            dataSource.title = self.viewModel.currencyKeys()
            dataSource.subtitle = self.viewModel.currencyName()
        }
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
