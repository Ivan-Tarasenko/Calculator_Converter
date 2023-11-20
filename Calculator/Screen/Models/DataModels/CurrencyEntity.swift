//
//  CurrencyEntity.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import Foundation

struct CurrencyEntity {
    var currency: [String: Currency]
    
    init?(currencyEntity: CurrentData) {
        currency = currencyEntity.valute
        
    }
}
