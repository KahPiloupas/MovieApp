//
//  MovieGridViewController.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 10/11/24.
//

import UIKit

class MovieGridViewController: UIViewController {
    
    private var viewModel = MovieGridViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
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
    
    private let loadView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .medium)
        loading.color = .white
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.isHidden = true
        loading.color = .black
        return loading
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
        viewModel.setDelegate(self)
        Task {
            await viewModel.fetchMovies(page: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        loadView.startAnimating()
        
//NavigationBar
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//SearchBar
        view.addSubview(searchBar)
        searchBar.delegate = self
        
//CollectionView
        view.addSubview(collectionView)
        view.addSubview(loadView)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(EmptySearchCollectionViewCell.self, forCellWithReuseIdentifier: "EmptySearchCollectionViewCell")
        collectionView.register(ErrorCollectionViewCell.self, forCellWithReuseIdentifier: "ErrorCollectionViewCell")
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            loadView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//Delegates da CollectionView
extension MovieGridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//Retorna o numero de iten da collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
//Retorna as celulas de acordo com o estado da ViewModel
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.getViewModelState {
            
        case .none:
            return UICollectionViewCell()
            
        case .showingMovies:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = viewModel.movie(at: indexPath.row)
            cell.configure(with: movie)
            return cell
            
        case .noMoviesFound:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptySearchCollectionViewCell", for: indexPath) as? EmptySearchCollectionViewCell
            cell?.setupCell(filmeName: viewModel.getSearchText)
            return cell ?? UICollectionViewCell()
            
        case .error:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCollectionViewCell", for: indexPath) as?
            ErrorCollectionViewCell
            return cell ?? UICollectionViewCell()
        }
    }
    
//Navega pra DetailViewController pra mostrar o detalhe do filme clicado
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath.row)
        let detailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
//Tamanho da celula mostrado de acordo com o estado da ViewModel
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.getViewModelState {
            
        case .none:
            return CGSize(width: 0, height: 0)
            
        case .showingMovies:
            return CGSize(width: movieCellWidth, height: 300)
            
        case .noMoviesFound:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case .error:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        }
    }
    
//Espaçamento entre as células
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
}

//Delegate Search Bar de acordo com a filtragem do filme que o usuario busca na searchBar
extension MovieGridViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterMovies(by: searchText)
   }
}

//Protocolos da ViewModel
extension MovieGridViewController: MovieGridViewModelProtocol {
    func showLoading() {
        loadView.isHidden = false
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func reloadData() {
        collectionView.reloadData()
        loadView.isHidden = true
    }
}

extension MovieGridViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollPosition = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if contentHeight - scrollPosition <= 100 { // Quando chegar perto do final da lista
            if !viewModel.isFetchingMoreMovies && searchBar.text == "" {
                Task {
                    await viewModel.fetchMoreMovies()
                }
            }
        }
    }
}
