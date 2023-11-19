//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    
    var mut: ViewModel!
    var nut: NetworkManager!
    let expectionPerfomingOperation = XCTestExpectation(description: "completionPerfomingOperation")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mut = ViewModel()
        nut = NetworkManager()
        
    }
    
    override func tearDownWithError() throws {
        mut = ViewModel()
        nut = NetworkManager()
        try super.tearDownWithError()
    }
    
    func testLimitInputNumbers() throws {
        let stringOne = " twenty  characters  "
        let stringTwo = "ten charac"
        let label = UILabel()
        var count = 1
        
        for _ in 1...3 {
            
            switch mut.isTyping {
            case true:
                if count == 1 {
                    mut.limitInput(for: stringTwo, andShowIn: label)
                    XCTAssertEqual(label.txt, stringTwo)
                    label.txt.removeAll()
                    count += 1
                } else {
                    mut.limitInput(for: stringOne, andShowIn: label)
                    XCTAssertEqual(label.txt, stringOne)
                }
            case false:
                mut.limitInput(for: stringOne, andShowIn: label)
                XCTAssertEqual(label.txt, stringOne)
                label.txt.removeAll()
            }
        }
    }
    
    func testdoNotEnterZeroFirst() throws {
        let label = UILabel()
        label.text = "0"
        mut.doNotEnterZeroFirst(for: label)
        XCTAssertFalse(mut.isTyping)
    }
    
    func testSaveFirstOperand() throws {
        mut.saveFirstОperand(from: 42)
        XCTAssertNotNil(mut.firstOperand)
        XCTAssertEqual(mut.firstOperand, 42)
    }
    
    func testSaveSignOperations() throws {
        mut.saveOperation(from: "+")
        XCTAssertNotNil(mut.operation)
        XCTAssertEqual(mut.operation, "+")
    }
    
    func testPerformingOperation() throws {
        var currentInput = 0.0
        mut.firstOperand = 15.0
        mut.secondOperand = 10.0
        mut.operation = "+"
        
        for _ in 1...4 {
            switch mut.operation {
            case "+":
                mut.performOperation(for: &currentInput)
                XCTAssertEqual(currentInput, 25)
                mut.operation = "-"
            case "-":
                currentInput = 0.0
                mut.firstOperand = 15.0
                mut.secondOperand = 10.0
                mut.performOperation(for: &currentInput)
                XCTAssertEqual(currentInput, 5)
                mut.operation = "×"
            case "×":
                currentInput = 0.0
                mut.firstOperand = 15.0
                mut.secondOperand = 10.0
                mut.performOperation(for: &currentInput)
                XCTAssertEqual(currentInput, 150)
                mut.operation = "÷"
            case "÷":
                currentInput = 0.0
                mut.firstOperand = 15.0
                mut.secondOperand = 10.0
                mut.performOperation(for: &currentInput)
                XCTAssertEqual(currentInput, 1.5)
            default:
                break
            }
        }
    }
    
    func testCalculatePercentage() throws {
        var currentInput = 10.0
        mut.firstOperand = 15.0
        mut.operation = "+"
        
        for _ in 1...4 {
            switch mut.operation {
            case "+":
                mut.calculatePercentage(for: &currentInput)
                XCTAssertEqual(currentInput, 16.5)
                mut.operation = "-"
            case "-":
                currentInput = 10.0
                mut.firstOperand = 15.0
                mut.calculatePercentage(for: &currentInput)
                XCTAssertEqual(currentInput, 13.5)
                mut.operation = "×"
            case "×":
                currentInput = 10.0
                mut.firstOperand = 15.0
                mut.calculatePercentage(for: &currentInput)
                XCTAssertEqual(currentInput, 1.5)
                mut.operation = "÷"
            case "÷":
                currentInput = 10.0
                mut.firstOperand = 15.0
                mut.calculatePercentage(for: &currentInput)
                XCTAssertEqual(currentInput, 150)
            default:
                break
            }
        }
    }
    
    func testEnteringFractionalNumber() throws {
        mut.isTyping = true
        mut.isDotPlaced = false
        let label = UILabel()
        label.text = "3"
        
        for _ in 1...2 {
            switch mut.isTyping {
            case true:
                mut.enterNumberWithDot(in: label)
                XCTAssertEqual(label.txt, "3.")
                mut.isTyping = false
                mut.isDotPlaced = false
            case false:
                mut.enterNumberWithDot(in: label)
                XCTAssertEqual(label.txt, "0.")
            }
        }
    }
    
    func testClearButton() throws {
        var currentValue = 42.0
        let label = UILabel()
        label.txt = "57"
        mut.firstOperand = 2.0
        mut.secondOperand = 3.0
        mut.operation = "-"
        mut.isTyping = true
        mut.isDotPlaced = true
        
        mut.clear(&currentValue, and: label)
        
        XCTAssertEqual(mut.firstOperand, 0)
        XCTAssertEqual(mut.secondOperand, 0)
        XCTAssertEqual(mut.operation, "")
        XCTAssertEqual(mut.isTyping, false)
        XCTAssertEqual(mut.isDotPlaced, false)
        XCTAssertEqual(label.txt, "0")
        XCTAssertEqual(currentValue, 0)
    }
    
    func testFetchData() throws {
        
        var testCurrency: [String: Currency]?
        var testError: Error?
        
//        nut.fetchData { data, error  in
//            testCurrency = data
//            testError = error
//            self.expectionPerfomingOperation.fulfill()
//        }
        
        wait(for: [expectionPerfomingOperation], timeout: 10)
        
        XCTAssertNotNil(testCurrency)
        XCTAssertNil(testError)
    }
    
    func testGetterCurrencyExchange() throws {
        let charCode = "USD"
        let quentity = 0.0
        var exhcange = String()
        
        mut.onUpDataCurrency = { _ in
            exhcange = self.mut.getCurrencyExchange(for: charCode, quantity: quentity)
            
            self.expectionPerfomingOperation.fulfill()
        }
        
        wait(for: [expectionPerfomingOperation], timeout: 10)
        XCTAssertNotNil(exhcange)
        XCTAssertNotEqual(Double(exhcange), 0)
    }
    
    func testCalculateCrossRate() throws {
        var exhcange = String()
        let quentity = 0.0
        var firstCurrencyVlue = 0.0
        var secondCurrencyValue = 0.0
        
        mut.onUpDataCurrency = { data in
            
            firstCurrencyVlue = data["USD"]!.value
            secondCurrencyValue = data["EUR"]!.value
            
            exhcange = self.mut.calculateCrossRate(
                for: firstCurrencyVlue,
                quantity: quentity,
                with: secondCurrencyValue
            )
            
            self.expectionPerfomingOperation.fulfill()
            
            XCTAssertNotNil(exhcange)
            XCTAssertNotEqual(Double(exhcange), 0)
        }
        
        wait(for: [self.expectionPerfomingOperation], timeout: 10)
    }
}
