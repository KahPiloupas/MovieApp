//
//  UIImageView+Extension.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 11/11/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    //Carregando Imagens assincrono
    func loadImageFromURL(_ url: URL, completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
        
        //Verifica se baixou a imagem e só mostra
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            completionHandler?(.success(cachedImage))
            return
        }
        
        //Baixa e salva a imagem no cache
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    self.image = UIImage(named: "emptyImage")
                    completionHandler?(.failure(error ?? ImageLoadingError.unknownError))
                    return
                }
                
                ImageCache.shared.setImage(image: image, forKey: url.absoluteString)
                self.image = image
                completionHandler?(.success(image))
            }
        }.resume()
    }
}

// Enum que representa os possíveis erros que podem ocorrer ao carregar uma imagem
enum ImageLoadingError: Error {
    case unknownError
}
