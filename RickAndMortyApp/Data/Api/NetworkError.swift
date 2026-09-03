//
//  NetworkError.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on  5/4/26.
//


import Foundation

enum NetworkError: Error {
    
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    
}
