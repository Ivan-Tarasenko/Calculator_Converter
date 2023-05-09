//
//  CrossCourseView.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class CrossCourseView: UIView {
    
    let toolBar = ToolBar()
    
    var dataSource = PickerDataSource()
    private let pickerView = UIPickerView()
    
    private let viewModel: ViewModelProtocol
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configereView()
        addConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private extensiion
private extension CrossCourseView {
    func configereView() {
        backgroundColor = .white
        pickerView.backgroundColor = R.Colors.pickerViewColor
        addSubview(pickerView)
        addSubview(toolBar)
    }
    
    func addConstraint() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.topAnchor.constraint(equalTo: toolBar.topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            toolBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolBar.topAnchor.constraint(equalTo: self.topAnchor)
            
        ])
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
