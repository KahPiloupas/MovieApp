//
//  FavoriteMovieViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

//Monto minha view de Favoritos
class FavoriteMovieViewController: UIViewController {
    
    private var favoriteMovies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 300)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var movieCellWidth: CGFloat {
        if UIDevice.current.orientation.isPortrait {
            return ( collectionView.frame.width - 70 )/2
        } else {
            return ( collectionView.frame.width - 70 )/3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadFavoriteMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavoriteMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "FavoriteMovieCell")
        collectionView.register(NoFavoritesMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "NoFavoritesMoviesCollectionViewCell")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//Carrega os filmes favoritos e depois atualiza a Collection
    private func loadFavoriteMovies() {
        favoriteMovies = PersistenceManager.loadFavoriteMovies()
        collectionView.reloadData()
    }
}

extension FavoriteMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoriteMovies.count > 0 {
            return favoriteMovies.count
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if favoriteMovies.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCell", for: indexPath) as! MovieCell
            cell.delegate = self
            let movie = favoriteMovies[indexPath.row]
            cell.configure(with: movie)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoFavoritesMoviesCollectionViewCell", for: indexPath) as! NoFavoritesMoviesCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = favoriteMovies[indexPath.row]
        let detailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if favoriteMovies.count > 0 {
            return CGSize(width: movieCellWidth, height: 300)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
}

//Caso um filme seja removido dos favoritos
extension FavoriteMovieViewController: MovieCellProtocol {
    func didUnfavoriteMovie() {
        loadFavoriteMovies()
    }
}
