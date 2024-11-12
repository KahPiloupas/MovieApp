//
//  FavoriteMovieViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

class FavoriteMovieViewController: UIViewController {
    
    private var favoriteMovies: [Movie] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 270)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadFavoriteMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavoriteMovies()
    }
    
    private func setupView() {
        view.backgroundColor = .lightGray
        title = "Favorites"
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "FavoriteMovieCell")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFavoriteMovies() {
        favoriteMovies = PersistenceManager.loadFavoriteMovies()
        collectionView.reloadData()
    }
}

extension FavoriteMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCell", for: indexPath) as! MovieCell
        cell.delegate = self
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = favoriteMovies[indexPath.row]
        let detailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FavoriteMovieViewController: MovieCellProtocol {
    func didUnfavoriteMovie() {
        loadFavoriteMovies()
    }
}
