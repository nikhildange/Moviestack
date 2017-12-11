//
//  PosterCollectionViewCell.swift
//  MoviesTack
//
//  Created by Nikhil Dange on 10/12/17.
//  Copyright © 2017 learn. All rights reserved.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    
    func displayContent(Of movie: MovieResponse.result) {
        movieLabel.text = movie.original_title
        if movie.poster_path != nil {
        movieImage.sd_setImage(with: URL.init(string: "https://image.tmdb.org/t/p/w130/"+movie.poster_path!), placeholderImage: UIImage.init(named: "movie_placeholder"), options: [], completed: nil)
        }
        else {
            movieImage.image = UIImage.init(named: "movie_placeholder")
        }
    }
}
