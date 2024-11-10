//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private let movie: Movie
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favorite", for: .normal)
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        fetchGenres()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(favoriteButton)
        view.addSubview(genresLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            genresLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            genresLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            favoriteButton.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configure() {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
            let isFavorite = PersistenceManager.isFavorite(movie: movie)
            let title = isFavorite ? "Unfavorite" : "Favorite"
            let image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "suit.heart")
            favoriteButton.setTitle(title, for: .normal)
            favoriteButton.setImage(image, for: .normal)
        }
    
    @objc private func toggleFavorite() {
        if PersistenceManager.isFavorite(movie: movie) {
            PersistenceManager.removeFavorite(movie: movie)
        } else {
            PersistenceManager.addFavorite(movie: movie)
        }
        updateFavoriteButton()
    }
    
    private func fetchGenres() {
        APIManagerGenre.fetchGenres { genres in
            let genreNames = self.movie.genreIds.compactMap { genreId in
                return genres.first { $0.id == genreId }?.name
            }
            self.genresLabel.text = "Genres: \(genreNames.joined(separator: ", "))"
        }
    }
}
