//
//  MovieCell.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

//Protocolo para desfavoritar um filme
protocol MovieCellProtocol: AnyObject {
    func didUnfavoriteMovie()
}

//Aqui eu crio a celula
class MovieCell: UICollectionViewCell {
    
    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    @objc private func toggleFavorite() {
        guard let movie = movie else { return }
        PersistenceManager.toggleFavorite(movie: movie)
        let isFavorite = PersistenceManager.isFavorite(movie: movie)
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "suit.heart"), for: .normal)
        
        delegate?.didUnfavoriteMovie() //esse delegate avisa para a tela de Favoritos que é necessário atualizar a lista de filmes
    }

    weak var delegate: MovieCellProtocol?
    private var movie: Movie?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .lightGray
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(movieImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

//Configuro a celula com as informaçoes do filme recebendo o objeto Movie e as propriedades dele (no caso, titulo e imagem)
    func configure(with movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.title
        if let imageUrl =  URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")") {
            movieImage.loadImageFromURL(imageUrl)
        }
        
        let isFavorite = PersistenceManager.isFavorite(movie: movie)
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "suit.heart"), for: .normal)
    }
}
