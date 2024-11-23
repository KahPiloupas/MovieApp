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
    
    private weak var delegate: MovieGridViewModelProtocol?
    private var service: MovieService = MovieService()
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var state: MovieCollectionViewState = .none
    private var searchText: String?
    private var page = 1
    
    var isFetchingMoreMovies: Bool = false
    
    var getViewModelState: MovieCollectionViewState {
        state
    }
    
    var moviesCount: Int {
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
    func fetchMovies(page: Int) async {
        await MainActor.run { delegate?.showLoading() } //Notifica a View que vai exibir um loading enquanto os filmes sao carregados
        //Requisição para buscar a lista dos filmes
        do {
            let response = try await service.fetchMovies(page: page)
            self.movies.append(contentsOf: response.results)
            self.filteredMovies = movies
            self.page = response.page + 1
            self.state = .showingMovies
            await MainActor.run { delegate?.reloadData() }
        } catch {
            self.state = .error
            await MainActor.run { delegate?.reloadData() }
        }
    }
    
    //Carrega mais filmes enquanto o scroll vai rolando pra baixo
    func fetchMoreMovies() async {
        isFetchingMoreMovies = true
        try await fetchMovies(page: self.page)
        isFetchingMoreMovies = false
    }
    
    var getSearchText: String {
        searchText ?? ""
    }
    
    //Filtra o filme de acordo com o que é escrito na busca
    func filterMovies(by searchText: String) {
        if searchText.isEmpty {
            Task {
                await fetchMovies(page: 1)
            }
        } else {
            self.searchText = searchText
            filteredMovies = movies.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) == true
            }
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
