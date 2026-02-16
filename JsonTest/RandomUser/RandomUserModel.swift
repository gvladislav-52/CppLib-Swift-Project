//
//  RandomUserModel.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import Foundation

struct RandomUserModel: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}
