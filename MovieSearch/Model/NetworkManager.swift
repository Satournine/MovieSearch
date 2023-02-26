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
    // Declaring two published variables that will hold search and details information
    @Published var movie = [Search]()
    @Published var details = [Details]()
    // Creating the URL to make a request to the API using the provided search term and API key
    func getMovies(searchTerm: String, completion: @escaping (Result<Movies, Error>) -> Void){
        let url = "http://www.omdbapi.com/?apikey=c618bcf0&s=\(searchTerm)"
        // Making the API request using Alamofire
        AF.request(url).response{ response in
            print(url)
            switch response.result{
            case .success:
                guard let data = response.data else{
                    print("Response data is nil")
                    return
                }
                // Using JSONDecoder to decode the response data to a Movies object and returning the successful response with movies
                let decoder = JSONDecoder()
                do {
                    let movies = try decoder.decode(Movies.self, from: data)
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
        // Function to get details of a movie based on its title
    func getDetails(detailsOf: String, completion: @escaping (Result<Details, Error>) -> Void){
        var url = "http://www.omdbapi.com/?apikey=c618bcf0&t=\(detailsOf)"
        // Replacing any spaces in the movie title with %20 as required by the API
        url = url.replacingOccurrences(of: " ", with: "%20")
        // Making the API request using Alamofire
        AF.request(url).responseDecodable(of: Details.self){ response in
            switch response.result{
            case .success(let data):
        // Logging an analytics event for successful movie detail view with movie title, genre and director
                Analytics.logEvent("Movie_Detail_Screen_Called", parameters: [
                    "Movie_Title": data.Title,
                    "Movie_Genre": data.Genre,
                    "Movie_Director": data.Director])
        // Returning the successful response with movie details
                completion(.success(data))
            case .failure(let error):
        // Logging an analytics event for failed movie detail view with "Get_Detail_Failure" parameter
                Analytics.logEvent("Movie_Detail_Screen_Called", parameters: [
                    "Get_Detail_Failure": "failure",
                    ])
                completion(.failure(error))

            }
        }
    }
    
    
    
}
