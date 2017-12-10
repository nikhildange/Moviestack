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
    
    func displayContent(image: UIImage?, name: String) {
        movieImage.image = image
        movieLabel.text = name
    }
}
