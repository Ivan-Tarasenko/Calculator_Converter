//
//  ViewModel.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import Foundation
import UIKit

protocol ViewModelProtocol: AnyObject {
    
    var isTyping: Bool { get set }
    
    var onUpDataCurrency: (([String: Currency]) -> Void)? { get set }
    var onFetchData: ((Bool) -> Void)? { get set }
    
    func limitInput(for inputValue: String, andShowIn label: UILabel)
    func clear(_ currentValue: inout Double, and label: UILabel)
    func calculatePercentage(for value: inout Double)
    func doNotEnterZeroFirst(for label: UILabel)
    func saveFirstОperand(from currentInput: Double)
    func saveOperation(from currentOperation: String)
    func performOperation(for value: inout Double)
    func enterNumberWithDot(in label: UILabel)
    
    func setDataFromDataBase()
    
    func getCurrencyExchange(for charCode: String, quantity: Double) -> String
    func calculateCrossRate(for firstOperand: Double, quantity: Double, with secondOperand: Double) -> String
}

final class ViewModel: ViewModelProtocol {
    
    var onUpDataCurrency: (([String: Currency]) -> Void)?
    var onFetchData: ((Bool) -> Void)?
    
    var isTyping = false
    var isDotPlaced = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operation: String = ""
    
    private var networkManager: NetworkManagerProtocol = NetworkManager()
    
    var currencies: [String: Currency]? {
        didSet {
            if let currency = currencies {
                onUpDataCurrency?(currency)
            }
        }
    }
    
    init() {
        setData()
    }
    
    func limitInput(for inputValue: String, andShowIn label: UILabel) {
        if isTyping {
            if label.txt.count < 20 {
                label.txt += inputValue
            }
        } else {
            label.txt = inputValue
            isTyping = true
        }
    }
    
    func doNotEnterZeroFirst(for label: UILabel) {
        if label.txt == "0" {
            isTyping = false
        }
    }
    
    func saveFirstОperand(from currentInput: Double) {
        firstOperand = currentInput
        isTyping = false
        isDotPlaced = false
    }
    
    func saveOperation(from currentOperation: String) {
        operation = currentOperation
    }
    
    func performOperation(for value: inout Double) {
        
        func performingAnOperation(with operand: (Double, Double) -> Double) {
            guard !secondOperand.isZero else { return }
            value = operand(firstOperand, secondOperand)
            isTyping = false
        }
        
        if isTyping {
            secondOperand = value
        }
        
        switch operation {
        case "+":
            performingAnOperation {$0 + $1}
        case "-":
            performingAnOperation {$0 - $1}
        case "×":
            performingAnOperation {$0 * $1}
        case "÷":
            performingAnOperation {$0 / $1}
        default:
            break
        }
        
        if value < firstOperand {
            firstOperand = value
        } else {
            secondOperand = value
        }
        
    }
    
    func calculatePercentage(for value: inout Double) {
        if firstOperand == 0 {
            value /= 100
        }
        switch operation {
        case "+":
            value = firstOperand + ((firstOperand / 100) * value)
        case "-":
            value = firstOperand - ((firstOperand / 100) * value)
        case "×":
            value = (firstOperand / 100) * value
        case "÷":
            value = (firstOperand / value) * 100
        default:
            break
        }
        isTyping = false
    }
    
    func enterNumberWithDot(in label: UILabel) {
        if isTyping && !isDotPlaced {
            isDotPlaced = true
            label.txt  += "."
        } else if !isTyping && !isDotPlaced {
            isTyping = true
            isDotPlaced = true
            label.txt = "0."
        }
    }
    
    func clear(_ currentValue: inout Double, and label: UILabel) {
        firstOperand = 0
        secondOperand = 0
        currentValue = 0
        label.txt = "0"
        operation = ""
        isTyping = false
        isDotPlaced = false
    }
    
        func setData() {
            let isEmpty = CoreDataService.shared.isDatabaseEmpty()
            isEmpty ? fetshData() : setDataFromDataBase()
        }
    
    func fetshData() {
        networkManager.fetchData { [weak self] data, statusCode, error in
            guard let self else { return }
            
            if error != nil { 
                DispatchQueue.main.async {
                    AlertService.shared.showAlert(title: R.Errors.warningAlert, massage: R.Errors.noData)
                }
            }
            
            if statusCode != nil {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.networkErrorHandling(status: statusCode!)
                }
            }
            
            if let data  = data {
                if let currentData = self.networkManager.parseJSON(withData: data) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.currencies = currentData.currency
                        CoreDataService.shared.save(data: data)
                    }
                }
            }
        }
    }
    
    func setDataFromDataBase() {
        CoreDataService.shared.getFetchData()
        
        guard let data = CoreDataService.shared.data?.value(forKey: DataEntity.keyAtribut)
                as? Data else { return }
        
        if let currentCurrencies = networkManager.parseJSON(withData: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.currencies = currentCurrencies.currency
                print("get data")
            }
        }
    }
    
    // MARK: - Сurrency exchange rate transactions
    func getCurrencyExchange(for charCode: String, quantity: Double) -> String {
        guard let currencies = currencies else { return "0" }
        var quantity = quantity
        if quantity == 0 {
            quantity = 1
        }
        let currency = currencies[charCode]
        let currencyValue = currency?.value
        let naminal = currency?.nominal
        let result = (currencyValue! / naminal!) * quantity
        let roundValue = round(result * 1000) / 1000
        isTyping = false
        return String(roundValue)
    }
    
    func calculateCrossRate(for firstOperand: Double, quantity: Double, with secondOperand: Double) -> String {
        var quantity = quantity
        if quantity == 0 {
            quantity = 1
        }
        let result = (quantity * firstOperand) / secondOperand
        let roundValue = round(result * 1000) / 1000
        isTyping = false
        return String(roundValue)
    }
    
    private func networkErrorHandling(status: Int) {
        switch status {
        case 402...499:
            AlertService.shared.showAlert(title: R.Errors.warningAlert, massage: R.Errors.clientError)
        case 500...599:
            AlertService.shared.showAlert(title: R.Errors.warningAlert, massage: R.Errors.serverError)
        default:
            break
        }
    }
}
