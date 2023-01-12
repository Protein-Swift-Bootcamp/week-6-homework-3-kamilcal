//
//  NewsAPI.swift
//  NewsApp
//
//  Created by kamilcal on 11.01.2023.
//

import UIKit

class NewsAPI {
    
    static let apiKey = "783293128b914179b4826ea2803ebcd1"
    
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
    // MARK: - getHeadlineNews
    class func getHeadlineNews(countryName: [String],
                               categoryName: String ,
                               completionHandler: @escaping ([Article],String,Int,Error?) -> Void) {
        NewsInfo.countryName = countryName[0]
        NewsInfo.categoryName = categoryName
        
        let url = (categoryName.isEmpty) ? Endpoints.getCountryHeadline.url : Endpoints.getCategoryHeadline.url
        newsGetRequest(countryName: countryName,
                       url: url,
                       responseType: NewsResponse.self) { response, errorMessage, statusCode, error in
            if let response = response {
                completionHandler(response.articles,countryName[1],statusCode,nil)
            } else {
                completionHandler([],errorMessage,statusCode,error)
            }
        }
    }
        
    // MARK: - searchForNews
    class func searchForNews(keyword:String ,
                             completionHandler: @escaping ([Article],String,Int,Error?) -> Void) {
        
        newsGetRequest(countryName: [""],
                       url: Endpoints.searchForNews(keyword).url,
                       responseType: NewsResponse.self) { response, errorMessage, statusCode, error in
            if let response = response {
                NewsInfo.totalPages = response.totalResults / 30
                completionHandler(response.articles,"",statusCode,nil)
            } else {
                completionHandler([],errorMessage,statusCode,error)
            }
        }
    }
    
    // MARK: - newsGetRequest
    class func newsGetRequest<ResponseType: Decodable>(countryName: [String],
                                                       url: URL,
                                                       responseType: ResponseType.Type,
                                                       completion: @escaping (ResponseType?,String,Int, Error?) -> Void) {
        NewsInfo.countryName = countryName[0]
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared
            .dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        completion(nil,"",0,error)
                    }
                    return
                }
                
                guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                    return
                }
                if httpStatusCode >= 200 && httpStatusCode < 300 {
                    let decoder = JSONDecoder()
                    do {
                        let responseObject = try decoder.decode(ResponseType.self, from: data!)
                        DispatchQueue.main.async {
                            completion(responseObject,"",httpStatusCode,nil)
                        }
                    } catch {
                        do {
                            let errorResponse = try decoder.decode(ErrorResponse.self, from: data!)
                            DispatchQueue.main.async {
                                completion(nil,errorResponse.message,1,error)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                completion(nil,"",0,error)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        switch httpStatusCode {
                        case 400: completion(nil,"",400,error)
                        case 401: completion(nil,"",401,error)
                        case 429: completion(nil,"",429,error)
                        case 404: completion(nil,"",404,error)
                        case 500: completion(nil,"",500,error)
                        default: completion(nil,"",0,error)
                        }
                    }
                }
            }
        task.resume()
    }
}
