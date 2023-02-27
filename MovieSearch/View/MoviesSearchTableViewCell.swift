//
//  MoviesSearchTableViewCell.swift
//  MovieSearch
//
//  Created by user226229 on 23.02.2023.
//

import UIKit

class MoviesSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLabelAppearance()
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setLabelAppearance() {
        // Initialization code
        movieNameLabel.layer.cornerRadius = 10
        movieNameLabel.layer.borderWidth = 1.0
        movieNameLabel.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
                let isDarkMode = self.traitCollection.userInterfaceStyle == .dark
                movieNameLabel.layer.borderColor = isDarkMode ? UIColor.systemIndigo.cgColor : UIColor.purple.cgColor
            } else {
                movieNameLabel.layer.borderColor = UIColor.systemPurple.cgColor
            }
        
    }


}
