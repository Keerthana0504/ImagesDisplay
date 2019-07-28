//
//  ViewController.swift
//  ImageDisplay
//
//  Created by Keerthana Reddy Ragi on 28/07/19.
//  Copyright © 2019 Keerthana Reddy Ragi. All rights reserved.
//

import UIKit

import UIKit

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var imagesTableView: UITableView!
    let store: Store = ImageDataSource()
    var images = [Photo]()
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find the Image"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search for Image"
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imagesTableView = UITableView.init(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: self.view.bounds.height - 20))
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        imagesTableView.showsVerticalScrollIndicator = false;
        imagesTableView.showsHorizontalScrollIndicator = false;
        imagesTableView.separatorStyle = .none
        imagesTableView.bounces = false;
        imagesTableView.scrollsToTop = true
        self.view.addSubview(imagesTableView)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count/3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Pagination
        if (indexPath.row * 3 > images.count - 9) {
            store.fetchMore { (result) in
                switch(result) {
                case .success(let images):
                    if(images.images.photo.count > 0) {
                        self.images.append(contentsOf: images.images.photo)
                        self.imagesTableView.reloadData()
                    } else {
                        self.showErrorToast(error: "No more results to display")
                    }
                case .error(let error):
                    self.showErrorAlert(errorTitle: "Something Not Right", errorMessage: error.localizedDescription)
                }
            }
        }
        
        if images.count >= indexPath.row * 3 {
            let item = indexPath.row * 3
            let cell = ImageDetailCell.init(width: Int(self.view.bounds.width), image1: images[item], image2: images[item + 1], image3: images[item + 2])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width/3
    }
}

extension ViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Don't want to make an API call for every letter typed. So skipped using this method.
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        handlingVCDisplay()
        if let text = searchController.searchBar.text?.lowercased(), !text.isEmpty {
            searchImages(search: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handlingVCDisplay()
    }
    
    func searchImages(search: String) {
        store.fetchImages(searchQuery: search) { (result) in
            switch(result) {
            case .success(let images):
                if(images.images.photo.count > 0) {
                    self.images = images.images.photo
                    self.imagesTableView.reloadData()
                } else {
                    self.showErrorAlert(errorTitle: "No Results Found", errorMessage: "Search word either doesn't have any results available or it's not a invalid search")
                }
            case .error(let error):
                self.showErrorAlert(errorTitle: "Something Not Right", errorMessage: error.localizedDescription)
            }
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        handlingVCDisplay()
    }
    
    func handlingVCDisplay() {
        self.view.addSubview(imagesTableView)
        imagesTableView.scrollRectToVisible(.zero, animated: false)
    }
}

extension ViewController {
    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.dismiss(animated: false) { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorToast(error: String) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 32, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.text = error
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .transitionCurlDown, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
