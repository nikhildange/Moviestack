//
//  ViewController.swift
//  MoviesTack
//
//  Created by Nikhil Dange on 10/12/17.
//  Copyright © 2017 learn. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let movieDataSource = MovieDataSource.sharedInstance
    var posterCellWidth = 0.0, posterCellHeight = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterCellWidth = Double(self.view.frame.size.width)/3.1
        posterCellHeight = posterCellWidth/0.67
        movieDataSource.getMovies(completion: {
            print(self.movieDataSource.movies);
            self.collectionView.reloadData()
        }, pageNumber: 1, callType: call_type.popular)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieDataSource.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCollectionViewCell", for: indexPath) as! PosterCollectionViewCell
        let movie = movieDataSource.movies[indexPath.row]
        cell.movieLabel.text = movie.original_title
        
        cell.movieImage.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: CGFloat(posterCellHeight/2), width: CGFloat(posterCellWidth), height: CGFloat(posterCellHeight))
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.2]
        cell.movieImage.layer.addSublayer(gradient)//insertSublayer(gradient, at: 0)
        
        cell.movieImage.sd_setImage(with: URL.init(string: "https://image.tmdb.org/t/p/w130/"+movie.poster_path), placeholderImage: nil, options: [], completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: posterCellWidth, height: posterCellHeight)
    }
}

