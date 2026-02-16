//
//  RickAndMortyViewModel.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import Foundation
import Combine

@MainActor
final class RickAndMortyViewModel: ObservableObject {
    
    @Published var characters: [RickAndMortyModel] = []
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()
    
    func fetchCharacters() {
        Task {
            do {
                let data = try await networkService.request(
                    endpoint: RickAndMortyEndpoint.characters
                )
                
                let parsed = try parse(data: data)
                self.characters = parsed
                
            } catch {
                self.errorMessage = "Something went wrong"
            }
        }
    }
    
    func parse(data: Data) throws -> [RickAndMortyModel] {
        
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw AppError.parsing
        }
        
        let cCharactersArray = parse_characters_from_json(jsonString)
        
        var swiftCharacters: [RickAndMortyModel] = []
        
        for i in 0..<cCharactersArray.count {
            let cChar = cCharactersArray.people
                .advanced(by: Int(i))
                .pointee
            
            swiftCharacters.append(
                RickAndMortyModel(
                    id: Int(cChar.id),
                    name: String(cString: cChar.name),
                    species: String(cString: cChar.species),
                    status: String(cString: cChar.status),
                    imageURL: String(cString: cChar.imageURL)
                )
            )
        }
        
        return swiftCharacters
    }

}
