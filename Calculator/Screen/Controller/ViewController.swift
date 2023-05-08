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
    @IBOutlet var buttons: [UIButton]!
    
    let viewModel: ViewModelProtocol = ViewModel()

    var currentInput: Double {
        get {
            return Double(displayLabel.txt)!
        }
        set {
            displayLabel.txt = String(format: "%g", newValue) // Getting rid of zero in a double
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configur(buttons: buttons)
       
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            topConstraint.constant = 142
        } else {
            topConstraint.constant = 10
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                var preferredStatusBarStyle: UIStatusBarStyle {
                    return .lightContent
                }
            } else {
                var preferredStatusBarStyle: UIStatusBarStyle {
                    return .darkContent
                }
            }
        }
    }
    
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
    
}

// MARK: - Private extension
private extension ViewController {
    func configur(buttons: [UIButton]) {
        for buttom in buttons {
            buttom.layer.cornerRadius = 15
        }
    }
}
