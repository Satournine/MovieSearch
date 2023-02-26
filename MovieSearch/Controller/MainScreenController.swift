//
//  ViewController.swift
//  MovieSearch
//
//  Created by user226229 on 23.02.2023.
//

import UIKit


class MainScreenController: UITableViewController, UISearchBarDelegate {
    // Private variable to hold the response from the API call
    private var response: Movies? {
        didSet{ // Update the table view data source whenever the response variable is set
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var selectedMovie: Search? // Private variable to hold the selected movie
    var networkManager = NetworkManager() // Instantiate a NetworkManager object to make API calls


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MovieSearch"
        setupSearchController() // Set up the search bar in the navigation bar
        
        
    }
    //  method to set up the search bar in the navigation bar
    private func setupSearchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    // UISearchBarDelegate method that gets called when the search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If the search term is invalid, show an alert to the user
        guard var text = searchBar.text, text.count > 1 else {let alert = UIAlertController(title: "Invalid Search", message: "Please enter a valid search term", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
            }
        let searchTerm = text.replacingOccurrences(of: " ", with: "%20")// Replace any spaces in the search term with "%20"
        // Make the API call to get the movies with the search term
        networkManager.getMovies(searchTerm: searchTerm) { result in
            switch result{
            // If the API call is successful, set the response variable and print the number of search results and titles
            case .success(let movies):
                self.response = movies
                print("Found \(movies.Search.count) search results")
                for searchResult in movies.Search{
                    print("Title: \(searchResult.Title)")
                }
                // If the API call fails, show an alert to the user
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "Failed to get search results: \(text)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                print("Failed to get search results: \(error)")

            }
        }
    }
    // UITableView methods for setting up the table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.Search.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesSearchTableViewCell
        let result = response?.Search[indexPath.row]
        cell.movieNameLabel.text = result?.Title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = response?.Search[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let movieDetailViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailView") as? MovieDetailViewController else{return}
        guard let movieTitle = selectedMovie?.Title else{return}
        print(movieTitle)
        movieDetailViewController.updateUI(movieName: movieTitle)
        //navigationController?.pushViewController(movieDetailViewController, animated: true)
        navigationController?.present(movieDetailViewController, animated: true)
    }


}

