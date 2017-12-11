//
//  MovieDataSource.swift
//  MoviesTack
//
//  Created by Nikhil Dange on 10/12/17.
//  Copyright © 2017 learn. All rights reserved.
//

import Foundation

struct MovieResponse : Codable {
    let page: Int?
    let total_pages: Int?
    let results: [result]?
    struct result: Codable {
        let id: Int
        let original_title: String
        let poster_path: String?
        let overview: String
        let vote_average: Float
        let release_date: String
    }
}

enum call_type {    // API call type
    case popular
    case top_rated
    case search(text: String)
}

class MovieDataSource {
    
    static let sharedInstance = MovieDataSource()
    fileprivate init(){}
    
    var current_page = 1
    var total_pages = 1
    var movies : [MovieResponse.result] = []
    
    func getMovies(completion: @escaping (_ with: Bool) -> Void, pageNumber: Int, callType: call_type) {
        var urlString = ""
        switch callType {
        case .popular:
            urlString = "https://api.themoviedb.org/3/movie/popular?api_key=e0903dd046b0a16e976e8ce340876698&page="+String(pageNumber)
            break
        case .top_rated:
            urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=e0903dd046b0a16e976e8ce340876698&page="+String(pageNumber)
            break
        case .search(let text):
            urlString = "https://api.themoviedb.org/3/search/movie?api_key=e0903dd046b0a16e976e8ce340876698&page="+String(pageNumber)+"&query="+text+""
            break
        }
        if pageNumber == 1 {
            movies = [MovieResponse.result]()
        }
        
        guard let url = URL(string: urlString) else { return }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("API Error: "+error!.localizedDescription)
                completion(false)
            }
            guard let data = data else { return }
            do {
                let responseData = try JSONDecoder().decode(MovieResponse.self, from: data)
//                print(responseData)
                self.current_page = responseData.page!
                self.total_pages = responseData.total_pages!
                self.movies+=responseData.results!
                
                DispatchQueue.main.async(execute: {
                    completion(true)
                })
            } catch let jsonError {
                print("API JSON Error :"+jsonError.localizedDescription)
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
            }.resume()
    }
}
