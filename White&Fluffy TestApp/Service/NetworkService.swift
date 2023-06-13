//
//  NetworkService.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func getRandomPhotos(completion: @escaping (Data?, Error?) -> Void)
    func getSearchPhotos(searchTerm: String, completion: @escaping (Data?, Error?) -> Void)
    func getInfoOfPhoto(id: String?, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getRandomPhotos(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = prepareRandomParams()
        let url = randomUrl(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    func getSearchPhotos(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParams(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    func getInfoOfPhoto(id: String?, completion: @escaping (Data?, Error?) -> Void) {
        guard let id = id else { return }
        let url = infoUrl(id: id)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func prepareRandomParams() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(30)
        return parameters
    }

    private func randomUrl(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    private func prepareHeader() -> [String: String] {
        var headers = [String: String]()
        let accessKey = "nlyTjq6Rrib0oKsmZcjZLPwDPyQrX1I072tCIEPCjyg"
        headers["Authorization"] = "Client-ID \(accessKey)"
        return headers
    }

    private func prepareParams(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }

    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    private func infoUrl(id: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/\(id)"
        return components.url!
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
