//
//  CategoriesViewController.swift
//  NewsApp
//
//  Created by kamilcal on 10.01.2023.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    let categoryTitles = ["Business", "Entertainment", "Health","Science","Sports","Technology"]
    let categoryImages = [UIImage(named: "Business"), UIImage(named: "Entertainment"), UIImage(named: "Health"), UIImage(named: "Science"),UIImage(named: "Sports"),UIImage(named: "Technology")]
    var selectedCategory = ""
    var loadedCountries = [Country]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension CategoriesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.imageView.image = categoryImages[indexPath.row]
        cell.categoryLabel.text = categoryTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoryTitles[indexPath.row]
        performSegue(withIdentifier: "CategorySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategorySegue" {
            let HeadlinesVC = segue.destination as! HeadlinesViewController
            HeadlinesVC.category = selectedCategory
            HeadlinesVC.loadedCountries = self.loadedCountries
        }
    }
}

