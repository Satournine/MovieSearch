//
//  ViewController.swift
//  MovieSearch
//
//  Created by user226229 on 23.02.2023.
//

import UIKit

class MainScreenController: UITableViewController, UISearchResultsUpdating {
    
    private var response: Movies? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main Screen"
        setupSearchController()
        
    }
    private func setupSearchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        if(text.count > 1){
            networkManager.getMovies(searchTerm: text) { result in
                switch result{
                case .success(let movies):
                    print("Found \(movies.Search.count) search results")
                    for searchResult in movies.Search{
                        print("Title: \(searchResult.Title)")
                    }
                case .failure(let error):
                    print("Failed to get search results: \(error)")
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.Search.count ?? .zero
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mov = response?.Search[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesSearchTableViewCell
        cell.movieNameLabel.text = mov?.Title
        return cell
    }


}

