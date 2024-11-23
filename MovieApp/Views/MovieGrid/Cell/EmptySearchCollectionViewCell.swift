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
        image.tintColor = .gray
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
        resultLabel.text = "Not found \"\(filmeName)\" in search!"
    }
    
    private func setupView() {
        contentView.addSubview(searchImage)
        contentView.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            searchImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50),
            searchImage.heightAnchor.constraint(equalToConstant: 150),
            searchImage.widthAnchor.constraint(equalToConstant: 150),
            
            resultLabel.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 12),
            resultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            resultLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
