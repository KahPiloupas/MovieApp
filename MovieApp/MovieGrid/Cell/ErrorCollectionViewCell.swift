//
//  ErrorCollectionViewCell.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 11/11/24.
//

import UIKit

//Celula de erro pra exibir que nao existe o filme buscado
class ErrorCollectionViewCell: UICollectionViewCell {
    private let errorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.image = UIImage(systemName: "xmark.circle.fill")
        image.tintColor = .black
        return image
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "Ocorreu um erro inesperado. Tente novamente mais tarde."
        label.textAlignment = .center
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
        contentView.addSubview(errorImage)
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            errorImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            errorImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorImage.heightAnchor.constraint(equalToConstant: 120),
            errorImage.widthAnchor.constraint(equalToConstant: 120),
            
            messageLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
