//
//  NewsAPI.swift
//  NewsApp
//
//  Created by kamilcal on 11.01.2023.
//

import UIKit

class NewsAPI {
    
    static let apiKey = "d4c64f40f2054a1ab74013208c050057"
    
    struct NewsInfo{
        static var countryName = ""
        static var categoryName = ""
        static var searchPage = 1
        static var totalPages = 0
        
    }
    
    enum Endpoints {
        static let headlinesBase = "https://newsapi.org/v2/top-headlines?"
        static let everythingBase = "https://newsapi.org/v2/everything?"
        
        case getCountryHeadline
        case getCategoryHeadline
        case searchForNews(String)
        
        var URLString: String {
            switch self {
            case .getCountryHeadline: return Endpoints.headlinesBase + "country=\(NewsInfo.countryName)"
            case .getCategoryHeadline: return Endpoints.headlinesBase + "country=\(NewsInfo.countryName)&category=\(NewsInfo.categoryName)"
            case .searchForNews(let query): return Endpoints.everythingBase + "q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&sortBy=publishedAt&language=en&pageSize=20&page=\(NewsInfo.searchPage)"
            }
        }
        var url: URL {
            return URL(string: URLString)!
        }
    }
    
    class func getHeadlineNews(countryName: [String],categoryName: String , completionHandler: @escaping ([Article],String,Int,Error?) -> Void) {
        
    }
    
    class func searchForNews(keyword:String , completionHandler: @escaping ([Article],String,Int,Error?) -> Void) {
        
    }
    
    class func newsGetRequest<ResponseType: Decodable>(countryName: [String],url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?,String,Int, Error?) -> Void) {
        
    }
    
}
