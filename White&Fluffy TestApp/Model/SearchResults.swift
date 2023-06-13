//
//  SearchResults.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 12.06.2023.
//

import Foundation

protocol Image {
    var id: String { get }
}

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Image, Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: [URLSize.RawValue: String]

    enum URLSize: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
    }
}

struct DetailedUnsplashPhoto: Image, Decodable {
    let id: String
    let createdAt: String
    let downloads: Int
    let location: Location?
    let user: User
    let urls: [URLSize.RawValue:String]

    enum URLSize: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case downloads
        case location
        case user
        case urls
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try map.decode(String.self, forKey: .id)
        self.createdAt = try map.decode(String.self, forKey: .createdAt)
        self.downloads = try map.decode(Int.self, forKey: .downloads)
        self.location = try? map.decode(Location.self, forKey: .location)
        self.user = try map.decode(User.self, forKey: .user)
        self.urls = try map.decode([URLSize.RawValue:String].self, forKey: .urls)
    }
}

struct User: Decodable {
    let name: String
}

struct Location: Decodable {
    var city: String
    var country: String
}

struct FavoritesPhotos {
    static var favorites = [DetailedUnsplashPhoto]()
}
