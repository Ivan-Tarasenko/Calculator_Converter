//
//  InfoViewController.swift
//  Calculator
//
//  Created by Иван Тарасенко on 22.11.2023.
//

import UIKit

final class InfoViewController: UIViewController {
    
    @IBOutlet weak var descriptionAPILabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizationLabels()
    }
    
    private func localizationLabels() {
        descriptionAPILabel.txt = NSLocalizedString("descAPI", comment: "")
    }
    
    func showAppVersion() {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.txt = appVersion
        } else {
            appVersionLabel.txt = "1.0.1"
        }
    }
}
