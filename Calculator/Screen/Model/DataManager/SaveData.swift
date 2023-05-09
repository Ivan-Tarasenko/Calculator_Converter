//
//  SaveData.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import Foundation

protocol SaveDataProtocol: AnyObject {
    var data: Data? { get set }
}

private struct KeysDefaults {
    static let keyData = "data"
}

final class SaveData: SaveDataProtocol {

    private let defaults = UserDefaults.standard

    var data: Data? {
        get {
            return defaults.data(forKey: KeysDefaults.keyData)
        }
        set {
            if let data = newValue {
                defaults.set(data, forKey: KeysDefaults.keyData)
            }
        }
    }
}
