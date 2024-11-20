//
//  NoFavoritesMoviesCollectionViewCell.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 19/11/24.
//

import UIKit

class NoFavoritesMoviesCollectionViewCell: UICollectionViewCell {
    private let xMarkImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.image = UIImage(systemName: "exclamationmark.triangle")
        image.tintColor = .gray
        return image
    }()
    
    private let favoritesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "You don't have favorite movies yet."
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(xMarkImage)
        contentView.addSubview(favoritesLabel)
        
        NSLayoutConstraint.activate([
            xMarkImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            xMarkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50),
            xMarkImage.heightAnchor.constraint(equalToConstant: 150),
            xMarkImage.widthAnchor.constraint(equalToConstant: 150),
            
            favoritesLabel.topAnchor.constraint(equalTo: xMarkImage.bottomAnchor, constant: 12),
            favoritesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoritesLabel.widthAnchor.constraint(equalToConstant: 300),
            favoritesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            favoritesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
