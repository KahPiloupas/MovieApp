//
//  ImageCache.swift
//  MovieApp
//
//  Created by Karina Piloupas Da Costa on 11/11/24.
//

import Foundation
import UIKit

//Aqui eu armazeno as imagens na memoria
class ImageCache {
    static let shared = ImageCache() //utilizo a mesma instancia do cache
    private let cache = NSCache<NSString, UIImage>()//posso armazenar strings e imagens
    private let cacheQueue = DispatchQueue(label: "ImageCache.ioQueue")//fila de execução de forma assincrona

    private init() {
        cache.countLimit = 100
    }

//Limpo todas as imagens armazenadas no cache conforme for ocorrendo a excecução com o Dispatch
    func clearCache() {
        cacheQueue.async {
            self.cache.removeAllObjects()
        }
    }

//Limito o numero de imagens no cache
    func setCacheLimited(value: Int) {
        cache.countLimit = value
    }

//Adiciono uma imagem ao cache
    func setImage(image: UIImage, forKey key: String) {
        cacheQueue.async {
            self.cache.setObject(image, forKey: key as NSString)
        }
    }

//Recupero a imagem do cache, caso ela ainda esteja la
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

}
