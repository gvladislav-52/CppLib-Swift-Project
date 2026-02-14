
import SwiftUI

struct RickAndMortyView: View {
    @State private var characters: [Character] = []

    var body: some View {
        VStack(spacing: 20) {

            if !characters.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(characters, id: \.id) { character in
                            HStack(alignment: .top, spacing: 12) {
                                if let url = URL(string: character.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Name: \(character.name)")
                                        .font(.headline)
                                    Text("Species: \(character.species)")
                                    Text("Status: \(character.status)")
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }

            Button("Load Rick & Morty Characters") {
                fetchCharacters()
            }
            .padding(.top)
        }
        .padding()
    }

    private func fetchCharacters() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let results = json?["results"] as? [[String: Any]] else { return }

                var simpleArray: [[String: Any]] = []

                for item in results {
                    guard
                        let id = item["id"] as? Int,
                        let name = item["name"] as? String,
                        let species = item["species"] as? String,
                        let status = item["status"] as? String,
                        let imageURL = item["image"] as? String
                    else { continue }

                    simpleArray.append([
                        "id": id,
                        "name": name,
                        "species": species,
                        "status": status,
                        "imageURL": imageURL
                    ])
                }

                let simpleData = try JSONSerialization.data(withJSONObject: simpleArray)
                guard let jsonString = String(data: simpleData, encoding: .utf8) else { return }

                let cCharactersArray = parse_characters_from_json(jsonString)

                var swiftCharacters: [Character] = []
                for i in 0..<cCharactersArray.count {
                    let cChar = cCharactersArray.people.advanced(by: Int(i)).pointee
                    swiftCharacters.append(Character(
                        id: Int(cChar.id),
                        name: String(cString: cChar.name),
                        species: String(cString: cChar.species),
                        status: String(cString: cChar.status),
                        imageURL: String(cString: cChar.imageURL)
                    ))
                }

                DispatchQueue.main.async {
                    self.characters = swiftCharacters
                }

            } catch {
                print("Error:", error)
            }
        }.resume()
    }

    struct Character {
        let id: Int
        let name: String
        let species: String
        let status: String
        let imageURL: String
    }
}
