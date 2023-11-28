//
//  ConverterViewModel.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import Foundation
import UIKit

protocol ConverterViewModelProtocol: AnyObject {
    
    var onUpDataCurrency: (([String: Currency]) -> Void)? { get set }
    var onDataLoaded: ((Bool) -> Void)? { get set }
    
    var isTyping: Bool { get set }
    
    func getCurrencyExchange(for charCode: String, quantity: Double) -> String
    func calculateCrossRate(for firstOperand: Double, quantity: Double, with secondOperand: Double) -> String
}

final class ConverterViewModel: ConverterViewModelProtocol {
    
    var onUpDataCurrency: (([String: Currency]) -> Void)?
    var onDataLoaded: ((Bool) -> Void)?
    
    var isTyping = false
    
    private var currencies: [String: Currency]? {
        didSet {
            if let currency = currencies {
                onUpDataCurrency?(currency)
            }
        }
    }
    
    private var networkManager: NetworkManagerProtocol = NetworkManager()
    private var loadedData = Data()
    
    init() {
        createTimer()
        installObserver()
    }
    
    // MARK: - Сurrency exchange rate transactions
    
    func getCurrencyExchange(for charCode: String, quantity: Double) -> String {
        guard let currencies = currencies else { return "0" }
        var quantity = quantity
        
        if quantity < 0 {
            quantity = -quantity
        }
        
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
        
        if quantity < 0 {
            quantity = -quantity
        }
        
        if quantity == 0 {
            quantity = 1
        }
        let result = (quantity * firstOperand) / secondOperand
        let roundValue = round(result * 1000) / 1000
        isTyping = false
        return String(roundValue)
    }
    
    // MARK: - Private methods
    
    // MARK: - Fetch and set data
    
    private func setData() {
        let isEmpty = CoreDataService.shared.isDatabaseEmpty()
        isEmpty ? fetchData() : setDataFromDataBase()
    }
    
    private func fetchData() {
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
                setCurrent(data: data)
                saveDataInDatabase(data)
                loadedData = data
            }
        }
    }
    
    private func saveDataInDatabase(_ data: Data) {
        DispatchQueue.main.async {
            CoreDataService.shared.save(data: data)
        }
    }
    
    private func setCurrent(data: Data) {
        if let currentData = self.networkManager.parseJSON(withData: data) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.currencies = currentData.currency
                self.onDataLoaded?(true)
            }
        }
    }
    
    private func setDataFromDataBase() {
        CoreDataService.shared.getFetchData()
        if let data = CoreDataService.shared.data?.value(forKey: DataEntity.attributeKey) as? Data {
            setCurrent(data: data)
        }
        
    }
    
    func updateData() {
        let isEmpty = CoreDataService.shared.isDatabaseEmpty()
        
        if !isEmpty {
            if !CoreDataService.shared.compareDataFromDatabase(and: loadedData) {
                fetchData()
            }
        }
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
    
    private func createTimer() {
        _ = Timer.scheduledTimer(timeInterval: 7200.0, target: self, selector: #selector(updateDataWithTimer), userInfo: nil, repeats: true)
    }
    
    private func installObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    // The function sets the output when the application comes to the foreground
    @objc private func appWillEnterForeground() {
        setData()
    }
    
    // The function updates the data every two hours
    @objc private func updateDataWithTimer() {
        updateData()
    }
}
