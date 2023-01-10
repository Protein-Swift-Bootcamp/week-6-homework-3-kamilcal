//
//  Article.swift
//  NewsApp
//
//  Created by kamilcal on 11.01.2023.
//

import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
