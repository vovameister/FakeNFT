//
//  RatingView.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 29.01.2024.
//
import UIKit

final class RatingView: UIStackView {
    private var stars: [UIImageView] = []
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup View
    private func setupStack() {
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        for _ in 1...5 {
            let starImageView = starView()
            stars.append(starImageView)
            addArrangedSubview(starImageView)
        }
    }
    // MARK: - Public Methods
    func createRating(with rating: Int) {
        for (index, imageView) in stars.enumerated() {
            let roundRating = Int(round(Double(rating / 2)))
            if index < roundRating {
                imageView.tintColor = .yaYellowUniversal
            } else {
                imageView.tintColor = .segmentInactive
            }
        }
    }
    // MARK: - Private Methods
    private func starView() -> UIImageView {
        let star = UIImageView()
        star.image = UIImage(systemName: "star.fill")
        star.contentMode = .scaleAspectFit
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }
}
