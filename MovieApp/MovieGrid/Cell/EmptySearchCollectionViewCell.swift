//
//  EmptySearchCollectionViewCell.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 11/11/24.
//

import UIKit

//Celula de busca vazia que não retorna nenhum filme buscado
class EmptySearchCollectionViewCell: UICollectionViewCell {
    private let searchImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.image = UIImage(systemName: "magnifyingglass")
        image.tintColor = .black
        return image
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
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
    
//Caso o estado da ViewModel tenha esse filme, ela exibe, caso nao, exibe essa mensagem
    func setupCell(filmeName: String) {
        resultLabel.text = "Não foi encontrado \"\(filmeName)\" na busca!!!"
    }
    
    private func setupView() {
        contentView.addSubview(searchImage)
        contentView.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            searchImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            searchImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchImage.heightAnchor.constraint(equalToConstant: 120),
            searchImage.widthAnchor.constraint(equalToConstant: 120),
            
            resultLabel.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 12),
            resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            resultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
