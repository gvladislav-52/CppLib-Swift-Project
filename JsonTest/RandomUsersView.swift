//
//  RandomUsersView.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.


import SwiftUI

struct RandomUsersView: View {
    @State private var people: [Person] = []

    var body: some View {
        VStack(spacing: 20) {

            if !people.isEmpty {
                ForEach(people, id: \.name) { person in
                    Text("Name: \(person.name), Age: \(person.age)")
                }
            }

            Button("Generate Random Users") {
                fetchRandomUsers()
            }
        }
        .padding()
    }

    private func fetchRandomUsers() {
        guard let url = URL(string: "https://randomuser.me/api/?results=5") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let results = json?["results"] as? [[String: Any]] else { return }

                var simpleArray: [[String: Any]] = []

                for user in results {
                    guard
                        let nameDict = user["name"] as? [String: Any],
                        let first = nameDict["first"] as? String,
                        let last = nameDict["last"] as? String,
                        let dob = user["dob"] as? [String: Any],
                        let age = dob["age"] as? Int
                    else { continue }

                    simpleArray.append([
                        "name": "\(first) \(last)",
                        "age": age
                    ])
                }

                let simpleData = try JSONSerialization.data(withJSONObject: simpleArray)
                guard let jsonString = String(data: simpleData, encoding: .utf8) else { return }
                print(jsonString)

                let cPeopleArray = parse_people_from_json(jsonString)

                var swiftPeople: [Person] = []
                for i in 0..<cPeopleArray.count {
                    let cPerson = cPeopleArray.people.advanced(by: Int(i)).pointee
                    swiftPeople.append(Person(name: String(cString: cPerson.name), age: Int(cPerson.age)))
                }

                DispatchQueue.main.async {
                    self.people = swiftPeople
                }


            } catch {
                print("Error:", error)
            }
        }.resume()
    }
    
    struct Person {
        let name: String
        let age: Int
    }
}
