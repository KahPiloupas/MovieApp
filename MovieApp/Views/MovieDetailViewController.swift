//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private let movie: Movie
    
    //Ativar uma scrollView para poder ver uma tela de detalhes bonita
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    //ContentView (pra abrigar todas as subviews)
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 3
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
        button.tintColor = .red
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
    
    override func viewWillAppear(_ animated: Bool) {
        updateFavoriteButton()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(genresLabel)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Garantir que o contentView tenha a mesma largura que o scrollView
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            posterImage.heightAnchor.constraint(equalToConstant: 500),
            
            titleLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genresLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            favoriteButton.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    //Configura o que a tela vai mostrar com base no que é pedido: imagem, o titulo de filme, sinopse dele e o botao de favoritos
    private func configure() {
        if let imageUrl =  URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")") {
            posterImage.loadImageFromURL(imageUrl)
        }
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        updateFavoriteButton()
    }
    
    //Verifica se o filme tá na lista de favoritos
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
            navigationController?.popViewController(animated: true)
        } else {
            PersistenceManager.addFavorite(movie: movie)
        }
        updateFavoriteButton()
    }
    
    private func fetchGenres() {
        //requisição pra buscar os filmes de acordo com seu genero e mapeia os IDs e nomes do genero deles
        APIManagerGenre.fetchGenres { result in
            switch result {
            case .success(let genres):
                let genreNames = self.movie.genreIds?.compactMap { genreId in
                    return genres.first { $0.id == genreId }?.name
                }
                DispatchQueue.main.async {
                    self.genresLabel.text = "Genres: \(genreNames?.joined(separator: ", ") ?? "")."
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.genresLabel.text = "Genres: undefined."
                }
                
            }
        }
    }
}
