//
//  NetworkService.swift
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

import Foundation

final class NetworkService {
    
    func request(endpoint: Endpoint) async throws -> Data {
        
        guard let url = endpoint.url else {
            throw AppError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.network
            }
            
            let statusCode = httpResponse.statusCode
            
            if statusCode < 200 || statusCode > 299 {
                throw AppError.network
            }
            
            return data
            
        } catch {
            throw AppError.network
        }
    }
}
