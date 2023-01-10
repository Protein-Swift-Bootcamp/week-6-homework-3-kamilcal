//
//  NewsResponse.swift
//  NewsApp
//
//  Created by kamilcal on 11.01.2023.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
