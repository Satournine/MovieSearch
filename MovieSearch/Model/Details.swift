//
//  Details.swift
//  MovieSearch
//
//  Created by user226229 on 25.02.2023.
//

import Foundation


struct Details: Codable{
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Ratings: [Rating]
    let `Type`: String
    let Response: String
}
struct Rating: Codable {
    let Source: String
    let Value: String
}
