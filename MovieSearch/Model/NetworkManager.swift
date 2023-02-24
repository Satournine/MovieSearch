//
//  NetworkManager.swift
//  MovieSearch
//
//  Created by user226229 on 23.02.2023.
//

import Foundation
import Alamofire

class NetworkManager: ObservableObject{
    
    @Published var movie = [Search]()
    
    func getMovies(searchTerm: String, completion: @escaping (Result<Movies, Error>) -> Void){
        let url = "http://www.omdbapi.com/?apikey=c618bcf0&s=\(searchTerm)"
        AF.request(url).response{ response in
            print(url)
            switch response.result{
            case .success:
                guard let data = response.data else{
                    print("Response data is nil")
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let movies = try decoder.decode(Movies.self, from: data)
                    print("Decoded movies:", movies)
                    self.movie = movies.Search
                    completion(.success(movies))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("fetch error: \(error)")
                
            }
        }
    }
}
