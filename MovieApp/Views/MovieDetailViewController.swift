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
    }
        
        private func setupView() {
            view.backgroundColor = .white
            view.addSubview(titleLabel)
            view.addSubview(overviewLabel)
            view.addSubview(favoriteButton)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                favoriteButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
                favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        private func configure() {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
        }
        
        @objc private func toggleFavorite() {
            if PersistenceManager.isFavorite(movie: movie) {
                PersistenceManager.removeFavorite(movie: movie)
            } else {
                PersistenceManager.addFavorite(movie: movie)
            }
        }
    }
