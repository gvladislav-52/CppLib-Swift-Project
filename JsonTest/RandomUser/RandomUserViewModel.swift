//
//  RandomUsersViewModel.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import Foundation
import Combine

@MainActor
final class RandomUsersViewModel: ObservableObject {
    
    @Published var people: [RandomUserModel] = []
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()
    
    func fetchRandomUsers() {
        Task {
            do {
                let data = try await networkService.request(
                    endpoint: RandomUsersEndpoint.users(count: 5)
                )
                
                let parsedPeople = try parse(data: data)
                self.people = parsedPeople
                
            } catch {
                self.errorMessage = "Something went wrong"
            }
        }
    }
    
    private func parse(data: Data) throws -> [RandomUserModel] {
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw AppError.parsing
        }
        
        let cPeopleArray = parse_people_from_json(jsonString)
        
        var swiftPeople: [RandomUserModel] = []
        
        for i in 0..<cPeopleArray.count {
            let cPerson = cPeopleArray.people
                .advanced(by: Int(i))
                .pointee
            
            swiftPeople.append(
                RandomUserModel(
                    name: String(cString: cPerson.name),
                    age: Int(cPerson.age)
                )
            )
        }
        
        return swiftPeople
    }

}
