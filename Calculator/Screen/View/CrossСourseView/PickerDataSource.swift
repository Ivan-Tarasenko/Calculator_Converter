//
//  PickerDataSource.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class PickerDataSource: NSObject, UIPickerViewDataSource {

    var currencies: [String: Currency] = [:]
    var title = [String]()
    var subtitle = [String]()
    var valueOfFirstCurrency: Double = 0
    var valueOfSecondCurrency: Double = 0
    var firstTitle: String = ""
    var secondTitle: String = ""

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        setValueOfFirstItems()
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
}

extension PickerDataSource: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let item = ItemView.create(
            title: title[row],
            subtitle: subtitle[row],
            wightItem: Int(pickerView.bounds.width)
        )
        
        return item
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = title[row]

        switch component {
        case 0:
            firstTitle = key
            valueOfFirstCurrency = currencies[key]!.value / currencies[key]!.nominal
        case 1:
            secondTitle = key
            valueOfSecondCurrency = currencies[key]!.value / currencies[key]!.nominal
        default:
            break
        }
    }

    func setValueOfFirstItems() {
        valueOfFirstCurrency = currencies[title[0]]!.value / currencies[title[0]]!.nominal
        valueOfSecondCurrency = currencies[title[0]]!.value / currencies[title[0]]!.nominal
        firstTitle = title[0]
        secondTitle = title[0]
    }
}
