//
//  NetworkDataFetcher.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 12.06.2023.
//

import Foundation

class NetworkDataFetcher {
    var networkService = NetworkService()

    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.getSearchPhotos(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }

    func fetchRandomImages(completion: @escaping ([UnsplashPhoto]?) -> Void) {
        networkService.getRandomPhotos { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            completion(decode)
        }
    }

    func fetchDetailedImage(id: String?, completion: @escaping (DetailedUnsplashPhoto?) -> Void) {
        guard let id = id else { return }
        networkService.getInfoOfPhoto(id: id) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: DetailedUnsplashPhoto.self, from: data)
            completion(decode)
        }
    }

    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
