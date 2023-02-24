//
//  Movies.swift
//  MovieSearch
//
//  Created by user226229 on 23.02.2023.
//

import Foundation

struct Movies: Codable {
    let Search: [Search]
    let totalResults, Response: String
}

struct Search: Codable {
    let Title, Year, imdbID: String
    let `Type`: String
    let Poster: String
}
