//
//  AppError.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import Foundation

enum AppError: Error {
    case invalidURL
    case network
    case noData
    case parsing
}
