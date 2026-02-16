//
//  Endpoint.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import Foundation

protocol Endpoint {
    var url: URL? { get }
}

enum RandomUsersEndpoint: Endpoint {
    case users(count: Int)
    
    var url: URL? {
        switch self {
        case .users(let count):
            return URL(string: "https://randomuser.me/api/?results=\(count)")
        }
    }
}

enum RickAndMortyEndpoint: Endpoint {
    case characters
    
    var url: URL? {
        switch self {
        case .characters:
            return URL(string: "https://rickandmortyapi.com/api/character")
        }
    }
}
