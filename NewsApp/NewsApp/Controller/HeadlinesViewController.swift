//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by kamilcal on 10.01.2023.
//

import UIKit
import CoreData

class HeadlinesViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var dataController = DataController.shared
    
    var articles = [Article]()
    var countriesNames = [String]()
    var loadedCountries = [Country]()
    
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromStorage()
        print("\(articles)")
    }
    
    //MARK: - response
    func handleHeadlineNewsResponse(articles: [Article] ,countryName: String,statusCode: Int, error: Error?) {
        if error != nil || statusCode != 200 {
            handleErrors(statusCode: statusCode,message: countryName ,error: error)
            return
        }
        for article in articles {
            if article.urlToImage != nil {
                self.articles.append(article)
                self.countriesNames.append(countryName)
            }
        }
        collectionView.reloadData()
    }
    //MARK: - request
    func requestHeadlinesForCountries(countries: [Country]){
        for country in countries {
            NewsAPI.getHeadlineNews(countryName: ["\(Countries(rawValue: country.country!)!)",
                                                  country.country!],
                                    categoryName: category,
                                    completionHandler:handleHeadlineNewsResponse(articles:countryName:statusCode:error:))
        }
    }
    //MARK: - fetch
    func fetchDataFromStorage() {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            loadedCountries = result
            requestHeadlinesForCountries(countries: loadedCountries)
        }
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HeadlinesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(articles.count)")
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HeadlinesCollectionViewCell
        if let articleImageString = articles[indexPath.row].urlToImage {
            
            let imageURL = URL(string: articleImageString)
            cell.imageView.downloaded(from: imageURL!)
//            TODO: imageview force unu kaldır!
        }
            cell.infoLabel.text = articles[indexPath.row].title
            return cell
        }
    }


