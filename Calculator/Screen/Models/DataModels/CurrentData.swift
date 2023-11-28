//
//  CurrentData.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import Foundation

// MARK: - CurrentData
struct CurrentData: Codable {
    let valute: [String: Currency]
    
    enum CodingKeys: String, CodingKey {
        case valute = "Valute"
    }
}

// MARK: - Currency
struct Currency: Codable {
    let nominal: Double
    let name: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
    }
}
