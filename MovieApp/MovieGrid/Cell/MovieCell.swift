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
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.setContentHuggingPriority(.defaultLow, for: .vertical)
//        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 4
        label.textColor = .black
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "unfavorite"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    @objc private func toggleFavorite() {
        guard let movie = movie else { return }
        PersistenceManager.toggleFavorite(movie: movie)
        let isFavorite = PersistenceManager.isFavorite(movie: movie)
        favoriteButton.setImage(UIImage(named: isFavorite ? "favorite" : "unfavorite"), for: .normal)
        
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
            movieImage.heightAnchor.constraint(equalToConstant: 210),
            
            titleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.heightAnchor.constraint(equalToConstant: 28),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28)
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
        favoriteButton.setImage(UIImage(named: isFavorite ? "favorite" : "unfavorite"), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFill
    }
}
