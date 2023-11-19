//
//  ViewController.swift
//  Calculator
//
//  Created by Иван Тарасенко on 08.05.2023.
//

import UIKit
import FirebaseCrashlytics

final class ViewController: UIViewController {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var multiCurrencyButton: MultiCurrencySelectionButton!
    @IBOutlet weak var crossCourseButton: BaseButton!
    
    var currentInput: Double {
        get {
            return Double(displayLabel.txt)!
        }
        set {
            displayLabel.txt = String(format: "%g", newValue) // Getting rid of zero in a double
        }
    }
    
    private var viewModel: ViewModelProtocol = ViewModel()
    private var crossCourseView = CrossCourseView()
    
    private var isLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationView()
        addConstraint()
        multiCurrencyButtonPressed()
        crossCourseDonePressed()
        crossCourseCancelPressed()
        sendData()
        checkIfDataHasLoaded()
        installObserver()
    }
    
    deinit {
        deinstallObsetver()
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
        if isLoaded {
            displayLabel.txt = viewModel.getCurrencyExchange(for: "USD", quantity: currentInput)
        } else {
            warnAboutMissingData()
        }
        
    }
    
    @IBAction func convertInEuroPressed(_ sender: UIButton) {
        if isLoaded {
            displayLabel.txt = viewModel.getCurrencyExchange(for: "EUR", quantity: currentInput)
        } else {
            warnAboutMissingData()
        }
    }
    
    @IBAction func crossCoursePressed(_ sender: UIButton) {
        if isLoaded {
            viewModel.clear(&currentInput, and: displayLabel)
            sender.titleLabel?.adjustsFontSizeToFitWidth = true
            crossCourseView.isHidden = false
        } else {
            warnAboutMissingData()
        }
    }
}

// MARK: - Private extension
private extension ViewController {
    
    func crossCourseDonePressed() {
        crossCourseView.onDoneAction = { [weak self] in
            guard let self else { return }
            
            crossCourseView.isHidden = true
            
            let crossRate = self.viewModel.calculateCrossRate(
                for: crossCourseView.dataSource.valueOfFirstCurrency,
                quantity: self.currentInput,
                with: crossCourseView.dataSource.valueOfSecondCurrency
            )
            self.displayLabel.txt = crossRate
            self.crossCourseButton.setTitle(
                " \(crossCourseView.dataSource.firstTitle)/\(crossCourseView.dataSource.secondTitle) ",
                for: .normal
            )
        }
    }
    
    func crossCourseCancelPressed() {
        crossCourseView.onCancelAction = { [weak self] in
            guard let self else { return }
            self.crossCourseView.isHidden = true
        }
    }
    
    func sendData() {
        viewModel.onUpDataCurrency = { [weak self] currencies in
            guard let self else { return }
            self.multiCurrencyButton.currencies = currencies
            self.multiCurrencyButton.setPopUpMenu(for: self.multiCurrencyButton)
            
            self.crossCourseView.currencies = currencies
            self.crossCourseView.bind()
        }
    }
    
    func multiCurrencyButtonPressed() {
        multiCurrencyButton.onActionMultiButton = { titles in
            self.displayLabel.txt = self.viewModel.getCurrencyExchange(
                for: titles[0],
                quantity: self.currentInput
            )
        }
    }
    
    func warnAboutMissingData() {
        AlertService.shared.showAlert(title: R.Errors.warningAlert, massage: R.Errors.noData)
    }
    
    func checkIfDataHasLoaded() {
        viewModel.onDataLoaded = { [weak self] isLoaded in
            guard let self else { return }
            self.isLoaded = isLoaded
        }
    }
    
    func configurationView() {
        view.addSubview(crossCourseView)
        crossCourseView.isHidden = true
    }
    
    func addConstraint() {
        crossCourseView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            crossCourseView.heightAnchor.constraint(equalToConstant: 270),
            crossCourseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            crossCourseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            crossCourseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // Tracking the orientation of the device when the application is launched
    func installObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func deinstallObsetver() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            topConstraint.constant = 6
        } else {
            topConstraint.constant = 140
        }
    }
}
