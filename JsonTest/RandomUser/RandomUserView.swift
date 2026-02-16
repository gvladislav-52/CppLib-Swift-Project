//
//  RandomUsersView.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import SwiftUI

struct RandomUsersView: View {

    @StateObject private var viewModel = RandomUsersViewModel()

    var body: some View {
        VStack(spacing: 20) {

            if !viewModel.people.isEmpty {
                ForEach(viewModel.people) { person in
                    Text("Name: \(person.name), Age: \(person.age)")
                }
            }

            Button("Generate Random Users") {
                viewModel.fetchRandomUsers()
            }
        }
        .padding()
    }
}

