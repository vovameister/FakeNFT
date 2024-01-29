//
//  RatingControl.swift
//  FakeNFT
//
//  Created by Кира on 29.01.2024.
//

import UIKit

class RatingControl: UIStackView {
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateRatingButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        for _ in 0..<5 {
            let button = UIButton()
            button.setImage(UIImage(named: "star"), for: .normal)
            button.setImage(UIImage(named: "filledStar"), for: .selected)
            button.setImage(UIImage(named: "filledStar"), for: [.highlighted, .selected])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 12).isActive = true
            button.widthAnchor.constraint(equalToConstant: 12).isActive = true
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        
    }
    
    private func updateRatingButtons() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
