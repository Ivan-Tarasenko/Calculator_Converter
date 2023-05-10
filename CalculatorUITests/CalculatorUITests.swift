//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import XCTest

final class CalculatorUITests: XCTestCase {

    let accessibility = AccessibilityIdentifier()

    var app: XCUIApplication!

    var resultLabel: XCUIElement!

    var clearButton: XCUIElement!
    var plusOrMinusButton: XCUIElement!
    var percentButton: XCUIElement!
    var squareRootButton: XCUIElement!
    var dotButton: XCUIElement!

    var plusButton: XCUIElement!
    var minusButton: XCUIElement!
    var multiplyButton: XCUIElement!
    var divisionButton: XCUIElement!
    var equallyButton: XCUIElement!

    var zeroButton: XCUIElement!
    var oneButton: XCUIElement!
    var twoButton: XCUIElement!
    var threeButton: XCUIElement!
    var fourButton: XCUIElement!
    var fiveButton: XCUIElement!
    var sixButton: XCUIElement!
    var sevenButton: XCUIElement!
    var eightButton: XCUIElement!
    var nineButton: XCUIElement!

    var dollarRateButton: XCUIElement!
    var euroRateButton: XCUIElement!
    var chooseCurrencyButton: XCUIElement!
    var crossRateButton: XCUIElement!

    var popUpButton: XCUIElement!

    var doneButtonPicker: XCUIElement!
    var cancelButtonPicker: XCUIElement!
    var pickerWheelsFirst: XCUIElement!
    var pickerWheelsSecond: XCUIElement!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        resultLabel = app.staticTexts[accessibility.resultLabel]

        clearButton = app.buttons[accessibility.clearButton]
        plusOrMinusButton = app.buttons[accessibility.plusOrMinusButton]
        percentButton = app.buttons[accessibility.percentButton]
        squareRootButton = app.buttons[accessibility.squareRootButton]
        dotButton = app.buttons[accessibility.dotButton]

        plusButton = app.buttons[accessibility.plusButton]
        minusButton = app.buttons[accessibility.minusButton]
        multiplyButton = app.buttons[accessibility.multiplyButton]
        divisionButton = app.buttons[accessibility.divisionButton]
        equallyButton = app.buttons[accessibility.equallyButton]

        zeroButton = app.buttons[accessibility.zeroButton]
        oneButton = app.buttons[accessibility.oneButton]
        twoButton = app.buttons[accessibility.twoButton]
        threeButton = app.buttons[accessibility.threeButton]
        fourButton = app.buttons[accessibility.fourButton]
        fiveButton = app.buttons[accessibility.fiveButton]
        sixButton = app.buttons[accessibility.sixButton]
        sevenButton = app.buttons[accessibility.sevenButton]
        eightButton = app.buttons[accessibility.eightButton]
        nineButton = app.buttons[accessibility.nineButton]

        dollarRateButton = app.buttons[accessibility.dollarRateButton]
        euroRateButton = app.buttons[accessibility.euroRateButton]
        chooseCurrencyButton = app.buttons[accessibility.chooseCurrencyButton]
        crossRateButton = app.buttons[accessibility.crossRateButton]

        popUpButton = app.buttons[accessibility.popUpButton]

        doneButtonPicker = app.buttons[accessibility.doneButtonPicker]
        cancelButtonPicker = app.buttons[accessibility.cancelButtonPicker]
        pickerWheelsFirst = app.pickerWheels.element(boundBy: 0)
        pickerWheelsSecond = app.pickerWheels.element(boundBy: 1)

    }
    
    override func tearDownWithError() throws {
        app = nil
    }

    func testForPresenceOfElements() throws {
        XCTAssertTrue(resultLabel.exists)

        XCTAssertTrue(clearButton.exists)
        XCTAssertTrue(plusOrMinusButton.exists)
        XCTAssertTrue(percentButton.exists)
        XCTAssertTrue(squareRootButton.exists)
        XCTAssertTrue(dotButton.exists)

        XCTAssertTrue(plusButton.exists)
        XCTAssertTrue(minusButton.exists)
        XCTAssertTrue(multiplyButton.exists)
        XCTAssertTrue(divisionButton.exists)
        XCTAssertTrue(equallyButton.exists)

        XCTAssertTrue(zeroButton.exists)
        XCTAssertTrue(oneButton.exists)
        XCTAssertTrue(twoButton.exists)
        XCTAssertTrue(threeButton.exists)
        XCTAssertTrue(fourButton.exists)
        XCTAssertTrue(fiveButton.exists)
        XCTAssertTrue(sixButton.exists)
        XCTAssertTrue(sevenButton.exists)
        XCTAssertTrue(eightButton.exists)
        XCTAssertTrue(nineButton.exists)

        XCTAssertTrue(dollarRateButton.exists)
        XCTAssertTrue(euroRateButton.exists)
        XCTAssertTrue(chooseCurrencyButton.exists)
        XCTAssertTrue(crossRateButton.exists)
    }

    func testPressNumbers() throws {
        let result = "1234567890"

        oneButton.tap()
        twoButton.tap()
        threeButton.tap()
        fourButton.tap()
        fiveButton.tap()
        sixButton.tap()
        sevenButton.tap()
        eightButton.tap()
        nineButton.tap()
        zeroButton.tap()

        XCTAssertEqual(resultLabel.label, result)
    }

    func testTwentyCharacterLimit() throws {
        let result = "12345678900987654321"

        oneButton.tap()
        twoButton.tap()
        threeButton.tap()
        fourButton.tap()
        fiveButton.tap()
        sixButton.tap()
        sevenButton.tap()
        eightButton.tap()
        nineButton.tap()
        zeroButton.tap()

        zeroButton.tap()
        nineButton.tap()
        eightButton.tap()
        sevenButton.tap()
        sixButton.tap()
        fiveButton.tap()
        fourButton.tap()
        threeButton.tap()
        twoButton.tap()
        oneButton.tap()
// More than twenty characters
        threeButton.tap()
        fiveButton.tap()

        XCTAssertEqual(resultLabel.label, result)
    }

    func testClearButton() throws {
        let result = "0"

        oneButton.tap()
        twoButton.tap()
        clearButton.tap()

        XCTAssertEqual(resultLabel.label, result)
    }

    func testOperations() throws {
        let resultOfAddition = "5"
        let resultOfSubtraction = "4"
        let resultOfMultiplication = "12"
        let resultDivision = "3"
// Addition
        twoButton.tap()
        plusButton.tap()
        threeButton.tap()
        equallyButton.tap()
        XCTAssertEqual(resultLabel.label, resultOfAddition)

// Subtraction
        clearButton.tap()
        nineButton.tap()
        minusButton.tap()
        fiveButton.tap()
        equallyButton.tap()
        XCTAssertEqual(resultLabel.label, resultOfSubtraction)

// Multiplication
        clearButton.tap()
        fourButton.tap()
        multiplyButton.tap()
        threeButton.tap()
        equallyButton.tap()
        XCTAssertEqual(resultLabel.label, resultOfMultiplication)

// Division
        clearButton.tap()
        sixButton.tap()
        divisionButton.tap()
        twoButton.tap()
        equallyButton.tap()
        XCTAssertEqual(resultLabel.label, resultDivision)

    }

    func testCurrencyRates() throws {
// Dollar rate
        dollarRateButton.tap()
        XCTAssertNotEqual(resultLabel.label, "0")
        clearButton.tap()

// Euro rate
        euroRateButton.tap()
        XCTAssertNotEqual(resultLabel.label, "0")
        clearButton.tap()

// The exchange rate of the selected currency
        chooseCurrencyButton.tap()
        popUpButton.tap()
        XCTAssertNotEqual(resultLabel.label, "0")
        clearButton.tap()

// Cross currency exchange rate
        crossRateButton.tap()
        pickerWheelsFirst.swipeUp()
        pickerWheelsSecond.swipeUp()
        pickerWheelsSecond.swipeUp()
        doneButtonPicker.tap()
        XCTAssertNotEqual(resultLabel.label, "0")
        
// PickerView hide
        crossRateButton.tap()
        cancelButtonPicker.tap()
        XCTAssertFalse(app.pickers.element.exists)

    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
