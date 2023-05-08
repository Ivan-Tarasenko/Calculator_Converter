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
    
    func limitInput(for inputValue: String, andShowIn label: UILabel)
    func clear(_ currentValue: inout Double, and label: UILabel)
    func calculatePercentage(for value: inout Double)
    func doNotEnterZeroFirst(for label: UILabel)
    func saveFirstОperand(from currentInput: Double)
    func saveOperation(from currentOperation: String)
    func performOperation(for value: inout Double)
    func enterNumberWithDot(in label: UILabel)
    
}

final class ViewModel: ViewModelProtocol {
    
    var isTyping = false
    private var isDotPlaced = false
    private var firstOperand: Double = 0
    private var secondOperand: Double = 0
    private var operation: String = ""
    
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
}
