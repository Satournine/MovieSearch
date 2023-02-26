//
//  NetworkManager.swift
//  MovieSearch
//
//  Created by user226229 on 23.02.2023.
//

import Foundation
import Alamofire
import FirebaseAnalytics

class NetworkManager: ObservableObject{
    
    @Published var movie = [Search]()
    @Published var details = [Details]()
    
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
    
    func getDetails(detailsOf: String, completion: @escaping (Result<Details, Error>) -> Void){
        var url = "http://www.omdbapi.com/?apikey=c618bcf0&t=\(detailsOf)"
        url = url.replacingOccurrences(of: " ", with: "%20")
        AF.request(url).responseDecodable(of: Details.self){ response in
            switch response.result{
            case .success(let data):
                Analytics.logEvent("Movie_Detail_Screen_Called", parameters: [
                    "Movie_Title": data.Title,
                    "Movie_Genre": data.Genre,
                    "Movie_Director": data.Director])
                completion(.success(data))
            case .failure(let error):
                Analytics.logEvent("Movie_Detail_Screen_Called", parameters: [
                    "Get_Detail_Failure": "failure",
                    ])
                
                
                
                completion(.failure(error))
                
            
                    
            }

            
            
        }
    }
    
    
    
}
