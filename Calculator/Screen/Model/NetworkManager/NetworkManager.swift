//
//  NetworkManager.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func fetchData(completion: @escaping ([String: Currency]?, Int?, Error?) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    private var saveData: SaveDataProtocol = SaveData()
    private var urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    
    // MARK: - Fetch data
    func fetchData(completion: @escaping ([String: Currency]?, Int?, Error?) -> Void) {
        guard let URL = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: URL) { data, response, error in
            
            if error != nil {
                completion(nil, nil, error)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, httpResponse.statusCode, nil)
                }
            }
            
            if let data = data {
                print("fetch")
                self.saveData.data = data
                if let currencyEntity =  self.parseJSON(withData: self.saveData.data!) {
                    DispatchQueue.main.async {
                        completion(currencyEntity.currency, nil, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> CurrencyEntity? {
        let decoder = JSONDecoder()
        do {
            let currentDate = try decoder.decode(CurrentData.self, from: data)
            guard let currencyEntity = CurrencyEntity(currencyEntity: currentDate) else { return nil }
            return currencyEntity
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
