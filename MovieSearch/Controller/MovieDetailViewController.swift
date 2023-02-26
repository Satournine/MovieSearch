//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by user226229 on 25.02.2023.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        movieNameLabel.text = "Movie Name"
//        moviePoster.backgroundColor = .gray
//        movieGenreLabel.text = "GenreGenre, Genre, GenreGenre"
//        movieDescriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
//        movieDirectorLabel.text = "Director Name Surname"
        
      
    }
    
    func updateUI(movieName: String){
        
        networkManager.getDetails(detailsOf: movieName) { result in
            switch result{
            case .success(let data):
                let imgURL = URL(string: data.Poster)
                self.moviePoster.kf.setImage(with: imgURL)
                self.movieNameLabel.text = data.Title
                self.movieGenreLabel.text = "Genre: \(data.Genre)"
                self.movieDescriptionLabel.text = data.Plot
                if data.Director != "N/A"{self.movieDirectorLabel.text = "Director: \(data.Director)"}else{
                    self.movieDirectorLabel.text = "Creator: \(data.Writer)"
                }
                
                
            case .failure(let error):
                debugPrint(error)
                self.movieNameLabel.text = nil
                self.movieGenreLabel.text = nil
                self.movieDescriptionLabel.text = nil
                self.movieDirectorLabel.text = nil
                let alertController = UIAlertController(title: "Oops", message: "Failed to fetch details", preferredStyle: .alert)
                let popAction = UIAlertAction(title: "OK", style: .default){ _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(popAction)
                self.present(alertController, animated: true)
                
            }
        
        }
        
    }
    
}
