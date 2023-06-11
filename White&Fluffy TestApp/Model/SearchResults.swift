//
//  SearchResults.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 12.06.2023.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue: String]
}

enum URLKing: String {
    case raw
    case full
    case regular
    case small
    case thumb
}
