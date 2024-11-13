//
//  MovieGridViewModel.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 12/11/24.
//

import Foundation

//Enum para mostrar os resultados da busca por filmes
enum MovieCollectionViewState {
    case none
    case showingMovies
    case noMoviesFound
    case error
}

//Métodos que a MovieGridViewController implementa pra acessar a ViewModel
protocol MovieGridViewModelProtocol: AnyObject {
    func showLoading()
    func reloadData()
    func showError(_ message: String)
}

class MovieGridViewModel {
    
    private var page = 1
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private weak var delegate: MovieGridViewModelProtocol?
    private var state: MovieCollectionViewState = .none
    private var searchText: String?
    
    var getViewModelState: MovieCollectionViewState {
        state
    }
    
    var allMovies: Int {
        return movies.count
    }
    
    var filteredMoviesCount: Int {
        return filteredMovies.count
    }
    
    func movie(at index: Int) -> Movie {
        return filteredMovies[index]
    }
    
    func setDelegate(_ delegate: MovieGridViewModelProtocol) {
        self.delegate = delegate
    }
    
//Carrega os filmes iniciais
    func fetchMovies() {
        self.delegate?.showLoading() //Notifica a View que vai exibir um loading enquanto os filmes sao carregados
        
        //Requisição para buscar a lista dos filmes
        MovieService.shared.fetchMovies { [weak self] (result: Result<MovieResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies = response.results
                self.filteredMovies = self.movies
                self.page = (response.page) + 1
                self.state = .showingMovies
                self.delegate?.reloadData()
            case .failure(_):
                self.state = .error
                self.delegate?.reloadData()
            }
        }
    }

//Carrega mais filmes enquanto o scroll vai rolando pra baixo
    func fetchMoreMovies() {
        MovieService.shared.fetchMoreMovies(newPage: page) { [weak self] (result: Result<MovieResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies.append(contentsOf: response.results)
                self.filteredMovies = self.movies
                self.page += 1
                self.state = .showingMovies
                self.delegate?.reloadData()
            case .failure(let error):
                print(error)
                self.state = .error
                self.delegate?.reloadData()
            }
        }
    }
    
    var getSearchText: String {
        searchText ?? ""
    }
    
//Filtra o filme de acordo com o que é escrito na busca
    func filterMovies(by searchText: String) {
        if searchText.isEmpty {
            fetchMovies()
        } else {
            self.searchText = searchText
            filteredMovies = movies.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) == true }
        }
        
        if filteredMovies.isEmpty {
            state = .noMoviesFound
        } else {
            state = .showingMovies
        }
        
        delegate?.reloadData()
    }
    
//Numero de filmes que sao mostrados na View
    func numberOfItems() -> Int {
        switch state {
        case .noMoviesFound, .error:
            return 1
        case .showingMovies:
            return filteredMovies.count
        default:
            return 0
        }
    }
}
