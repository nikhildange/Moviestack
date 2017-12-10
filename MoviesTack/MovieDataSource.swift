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
//    let total_pages: Int?
    let results: [result]?
    struct result: Codable {
        let id: Int
        let original_title: String
        let poster_path: String
        let overview: String
        let vote_average: Float
        let release_date: String
    }
}

enum call_type : String {
    case popular
    case top_rated
    case search
}

class MovieDataSource {
    
    static let sharedInstance = MovieDataSource()
    fileprivate init(){}
    var movies : [MovieResponse.result] = []
    
    func getMovies(completion: @escaping () -> Void, pageNumber: Int, callType: call_type) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=e0903dd046b0a16e976e8ce340876698&page="+String(pageNumber)
        //        if (callType != nil) {
        //            urlString = urlString+"&sort="+(callType?.rawValue)!
        //        }
        guard let url = URL(string: urlString) else { return }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("API Error: "+error!.localizedDescription)
            }
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                let responseData = try JSONDecoder().decode(MovieResponse.self, from: data)
                print(responseData)
                self.movies = responseData.results!
                
                DispatchQueue.main.async(execute: {
                    completion()
                })
            } catch let jsonError {
                print("API JSON Error :"+jsonError.localizedDescription)
            }
            }.resume()
    }
}
