//
//  ItemView.swift
//  Calculator
//
//  Created by Иван Тарасенко on 09.05.2023.
//

import UIKit

final class ItemView: UIView {
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private var wightItem = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitle()
        setupSubtitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func create(title: String, subtitle: String, wightItem: Int) -> ItemView {
        
        let itemView = ItemView()
        itemView.wightItem = wightItem
        itemView.title.txt = title
        itemView.subtitle.txt = subtitle
        
        itemView.title.translatesAutoresizingMaskIntoConstraints = false
        itemView.subtitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemView.title.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 7),
            itemView.title.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 2),
            
            itemView.subtitle.topAnchor.constraint(equalTo: itemView.title.topAnchor, constant: 23),
            itemView.subtitle.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 7),
            itemView.subtitle.heightAnchor.constraint(equalToConstant: 20),
            itemView.subtitle.widthAnchor.constraint(equalToConstant: CGFloat((wightItem / 2 - 5)))
            
        ])
        return itemView
    }
}

// MARK: - Private extension
private extension ItemView {
    func setupTitle() {
        addSubview(title)
        title.font = UIFont.systemFont(ofSize: 20)
    }
    
    func setupSubtitle() {
        addSubview(subtitle)
        subtitle.font = UIFont.systemFont(ofSize: 16)
        subtitle.textColor = R.Colors.subtitleColor
    }
}
