//
//  ErrorResponse.swift
//  NewsApp
//
//  Created by kamilcal on 11.01.2023.
//

import Foundation

struct ErrorResponse: Codable {
    let status: String
    let code: String
    let message: String
}
