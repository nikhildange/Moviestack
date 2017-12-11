//
//  DetailViewController.swift
//  MoviesTack
//
//  Created by Nikhil Dange on 11/12/17.
//  Copyright © 2017 learn. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var movieInfo: MovieResponse.result? = nil
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movieInfo  {
            posterImageView.sd_showActivityIndicatorView()
            if movie.poster_path != nil {
            posterImageView.sd_setImage(with: URL.init(string: "https://image.tmdb.org/t/p/w300/"+movie.poster_path!), placeholderImage: UIImage.init(named: "movie_placeholder"), options: [], completed: nil)
            }
            else {
                posterImageView.image = UIImage.init(named: "movie_placeholder")
            }
            titleLabel.text = movie.original_title.uppercased()
            dateLabel.text = movie.release_date
            ratingLabel.text = "⭐️ "+String(movie.vote_average)
            overviewTextView.text = movie.overview
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.overviewTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}
