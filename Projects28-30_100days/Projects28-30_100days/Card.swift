//
//  Card.swift
//  Projects28-30_100days
//
//  Created by user228564 on 5/1/23.
//

import UIKit


class CardCell: UICollectionViewCell {
    
    var cardValue: String?

    var arrayType: Bool?
    var isFlipped: Bool = false
    
    let frontLabel: UILabel = {
            let label = UILabel()
            
            label.textAlignment = .center
            label.textColor = .black
            return label
        }()
        
        let backLabel: UILabel = {
            let label = UILabel()
            label.text = "?"
            label.font = UIFont.systemFont(ofSize: 30)
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = .black
            return label
        }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubview(frontLabel)
            frontLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                frontLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                frontLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                frontLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                frontLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            
            contentView.addSubview(backLabel)
            backLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                backLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                backLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                backLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            
            
        }
        
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configure(withItem cardValue: String) {
        self.cardValue = cardValue
        frontLabel.text = cardValue
    }
    
    func flip() {
        UIView.transition(from: backLabel, to: frontLabel, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        UIView.transition(from: frontLabel, to: backLabel, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
}
