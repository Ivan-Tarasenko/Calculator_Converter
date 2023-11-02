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
    var isFetchData: Bool { get }
    
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
    
    func fetchData()
    
    func getCurrencyExchange(for charCode: String, quantity: Double) -> String
    func calculateCrossRate(for firstOperand: Double, quantity: Double, with secondOperand: Double) -> String
    func currencyKeys() -> [String]
    func currencyName() -> [String]
    
    func showAlert(on view: UIViewController, title: String, massage: String)
}

final class ViewModel: ViewModelProtocol {
    
    var onUpDataCurrency: (([String: Currency]) -> Void)?
    var onFetchData: ((Bool) -> Void)?
    
    var isTyping = false
    var isFetchData = true
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
        fetchData()
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
    
    // MARK: - Fetch Data
     func fetchData() {
        networkManager.fetchData { [weak self] currencies, responseCode, error  in
            guard let self else { return }
            
            print("error \(error)")
            print("response \(responseCode)")
            
            guard error == nil else {
                self.isFetchData = false
                self.onFetchData?(self.isFetchData)
                return }
            
            self.currencies = currencies
        }
    }
    
    // MARK: - Сurrency exchange rate transactions
    func currencyKeys() -> [String] {
        var keys = [String]()
        for (key, _) in sortCurrency() {
            keys.append(key)
        }
        return keys
    }
    
    func currencyName() -> [String] {
        var names = [String]()
        for (_, value) in sortCurrency() {
            names.append(value.name)
        }
        return names
    }
    
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
    
    func showAlert(on view: UIViewController, title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(cancel)
        view.present(alert, animated: true)
    }
    
    private func sortCurrency() -> [Dictionary<String, Currency>.Element] {
        var sort: [Dictionary<String, Currency>.Element] = []
        if let currencies = currencies {
            sort = currencies.sorted(by: {$0.key < $1.key})
        }
        return sort
    }
}
