//
//  MovieGridViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

class MovieGridViewController: UIViewController {
    
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var isLoading = false
    private var error: String?
    
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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        let image = UIImage(systemName: "magnifyingglass")
        searchBar.setImage(image, for: .search, state: .normal)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchMovies()
    }
    
        override func viewWillAppear(_ animated: Bool) {
            collectionView.reloadData()
        }
    
    private func setupView() {
        view.backgroundColor = .white
        
        //NavigationBar
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //SearchBar
        view.addSubview(searchBar)
        searchBar.delegate = self
        
        //CollectionView
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchMovies() {
        isLoading = true
        
        MovieService.shared.fetchPopularMovies { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.filteredMovies = movies
            case .failure(let error):
                self?.error = error.localizedDescription
            }
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

extension MovieGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let detailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MovieGridViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
   }
}
