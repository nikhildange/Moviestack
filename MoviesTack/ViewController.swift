//
//  ViewController.swift
//  MoviesTack
//
//  Created by Nikhil Dange on 10/12/17.
//  Copyright © 2017 learn. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let movieDataSource = MovieDataSource.sharedInstance
    var posterCellWidth = 0.0, posterCellHeight = 0.0
    var isPageRefreshing = true
    var callType = call_type.popular
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterCellWidth = Double(self.view.frame.size.width)/3.1
        posterCellHeight = posterCellWidth/0.67
        
        movieDataSource.getMovies(completion: {success in
            self.isPageRefreshing = false;
            if success {
                self.collectionView.reloadData() }
        }, pageNumber: 1, callType: callType)
        
        addSearchBar()
    }
    
    func addSearchBar() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Movies"
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    //MARK: SearchBar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 0 {
            isPageRefreshing = true
            callType = call_type.search(text: text)
            LoadingView.show()
            movieDataSource.getMovies(completion: {success in self.isPageRefreshing = false;
                if success {
                    self.collectionView.reloadData();
                    LoadingView.hide()
                    if self.movieDataSource.movies.count > 0 {
                        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                } }
                , pageNumber: 1, callType: callType)
        }
        removeSearchBar(searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeSearchBar(searchBar)
    }
    
    func removeSearchBar(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    //MARK: CollectionView Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieDataSource.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: posterCellWidth, height: posterCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isPageRefreshing {
            print(movieDataSource.movies[indexPath.row].original_title)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
            vc.movieInfo = movieDataSource.movies[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCollectionViewCell", for: indexPath) as! PosterCollectionViewCell
        if indexPath.row < movieDataSource.movies.count {
            let movie = movieDataSource.movies[indexPath.row]
            cell.displayContent(Of: movie)
            addGradientOn(cell.movieImage)
        }
        return cell
    }

    //Fade effect on imageView
    func addGradientOn(_ imageView: UIImageView) {
        imageView.layoutIfNeeded()
        imageView.layer.sublayers = nil
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: CGFloat(posterCellHeight/2), width: CGFloat(posterCellWidth), height: CGFloat(posterCellHeight))
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.2]
        imageView.layer.addSublayer(gradient)
    }
    
    
    //For Pagination
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height-CGFloat(posterCellHeight))) {
            if isPageRefreshing == false && movieDataSource.current_page < movieDataSource.total_pages {
//                print("Calling page "+String(movieDataSource.current_page+1)+" of "+String(movieDataSource.total_pages))
                isPageRefreshing = true
                movieDataSource.getMovies(completion: {success in self.isPageRefreshing = false;
                    if success {
                        self.collectionView.reloadData() } }
                    , pageNumber: movieDataSource.current_page+1, callType: callType)
            }
        }
    }
    
    //Sort ActionSheet on tapping setting button
    @IBAction func didTapSettingButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        
        func sortBy() {
            isPageRefreshing = true
            LoadingView.show()
            movieDataSource.getMovies(completion: {success in self.isPageRefreshing = false;
                if success {
                    self.collectionView.reloadData();
                    LoadingView.hide()
                    if self.movieDataSource.movies.count > 0 {
                        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                } }
                , pageNumber: 1, callType: callType)
        }
        
        alert.addAction(UIAlertAction(title: "Popular Movies", style: .default , handler:{ (UIAlertAction)in
            print("popular")
            self.callType = call_type.popular
            sortBy()
        }))
        alert.addAction(UIAlertAction(title: "Top Rated Movies", style: .default , handler:{ (UIAlertAction)in
            print("top_rated")
            self.callType = call_type.top_rated
            sortBy()
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}

