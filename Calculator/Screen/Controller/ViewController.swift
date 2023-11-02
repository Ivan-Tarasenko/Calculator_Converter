//
//  ViewController.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var multiCurrencyButton: MultiCurrencySelectionButton!
    @IBOutlet weak var crossCourseButton: BaseButton!
    @IBOutlet var buttons: [UIButton]!
    
    var currentInput: Double {
        get {
            return Double(displayLabel.txt)!
        }
        set {
            displayLabel.txt = String(format: "%g", newValue) // Getting rid of zero in a double
        }
    }
    
    private let viewModel: ViewModelProtocol = ViewModel()
    private var crossCourseView: CrossCourseView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        crossCourseView = CrossCourseView(viewModel: viewModel)
        
        configurationView()
        addConstraint()
        multiCurrencyButtonPressed()
        checkFetchData()
        crossCourseDonePressed()
        crossCourseCancelPressed()
        sendHeadersInMultiCurrencyButtun()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            topConstraint.constant = 142
        } else {
            topConstraint.constant = 10
        }
    }
    
    // MARK: - Actions
    @IBAction func clearPressed(_ sender: UIButton) {
        viewModel.clear(&currentInput, and: displayLabel)
    }
    
    @IBAction func reverseSingPressed(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func procentPressed(_ sender: UIButton) {
        viewModel.calculatePercentage(for: &currentInput)
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        viewModel.doNotEnterZeroFirst(for: displayLabel)
        viewModel.limitInput(for: sender.currentTitle!, andShowIn: displayLabel)
        sender.accessibilityIdentifier = "number \(String(describing: sender.titleLabel?.txt))"
        
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        viewModel.saveFirstОperand(from: currentInput)
        viewModel.saveOperation(from: sender.currentTitle!)
    }
    
    @IBAction func equalityPressed(_ sender: UIButton) {
        viewModel.performOperation(for: &currentInput)
    }
    
    @IBAction func sqrtPressed(_ sender: UIButton) {
        currentInput = sqrt(currentInput)
        viewModel.isTyping = false
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        viewModel.enterNumberWithDot(in: displayLabel)
    }
    
    @IBAction func convertDollarPressed(_ sender: UIButton) {
        displayLabel.txt = viewModel.getCurrencyExchange(for: "USD", quantity: currentInput)
    }
    
    @IBAction func convertInEuroPressed(_ sender: UIButton) {
        displayLabel.txt = viewModel.getCurrencyExchange(for: "EUR", quantity: currentInput)
    }
    
    private func multiCurrencyButtonPressed() {
        multiCurrencyButton.onActionMultiButton = { titles in
            self.displayLabel.txt = self.viewModel.getCurrencyExchange(
                for: titles[0],
                quantity: self.currentInput
            )
        }
    }
    
    @IBAction func crossCoursePressed(_ sender: UIButton) {
        viewModel.clear(&currentInput, and: displayLabel)
        sender.titleLabel?.adjustsFontSizeToFitWidth = true
        crossCourseView?.isHidden = false
    }
    
    private func crossCourseDonePressed() {
        guard let crossCoerseView = self.crossCourseView else { return }
        
        crossCoerseView.onDoneAction = { [weak self] in
            guard let self else { return }
            
            crossCoerseView.isHidden = true
            
            let crossRate = self.viewModel.calculateCrossRate(
                for: crossCoerseView.dataSource.valueOfFirstCurrency,
                quantity: self.currentInput,
                with: crossCoerseView.dataSource.valueOfSecondCurrency
            )
            self.displayLabel.txt = crossRate
            self.crossCourseButton.setTitle(
                " \(crossCoerseView.dataSource.firstTitle)/\(crossCoerseView.dataSource.secondTitle) ",
                for: .normal
            )
        }
    }
    
    private func crossCourseCancelPressed() {
        crossCourseView?.onCancelAction = { [weak self] in
            guard let self else { return }
            self.crossCourseView?.isHidden = true
        }
    }
    
    private func sendHeadersInMultiCurrencyButtun() {
        viewModel.onUpDataCurrency = { currencies in
            self.multiCurrencyButton.currencies = currencies
            self.multiCurrencyButton.setPopUpMenu(for: self.multiCurrencyButton)
        }
    }
}
    
    // MARK: - Private extension
    private extension ViewController {
        
        func configurationView() {
            guard let crossCoerseView = crossCourseView else { return }
            view.addSubview(crossCoerseView)
            crossCoerseView.isHidden = true
        }
        
        func addConstraint() {
            guard let crossCoerseView = crossCourseView else { return }
            crossCoerseView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                crossCoerseView.heightAnchor.constraint(equalToConstant: 270),
                crossCoerseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                crossCoerseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                crossCoerseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
        
        func checkFetchData() {
            viewModel.onFetchData = { [weak self] isFetchData in
                guard let self else { return }
                if !isFetchData {
                    DispatchQueue.main.async {
                        self.viewModel.showAlert(on: self, title: R.Titles.warningAlert, massage: R.Titles.massageAlert)
                    }
                }
            }
        }
    }
