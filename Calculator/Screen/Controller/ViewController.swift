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
    
    private var viewModel: ViewModelProtocol = ViewModel()
    private var crossCourseView = CrossCourseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationView()
        addConstraint()
        multiCurrencyButtonPressed()
        crossCourseDonePressed()
        crossCourseCancelPressed()
        sendData()
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
    
    @IBAction func crossCoursePressed(_ sender: UIButton) {
        viewModel.clear(&currentInput, and: displayLabel)
        sender.titleLabel?.adjustsFontSizeToFitWidth = true
        crossCourseView.isHidden = false
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
}
