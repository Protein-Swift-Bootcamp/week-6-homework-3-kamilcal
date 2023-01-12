//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by kamilcal on 10.01.2023.
//

import UIKit
import CoreData
import AVKit
import AVFoundation

class HeadlinesViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var dataController = DataController.shared
    
    var articles = [Article?]()
    var countriesNames = [String]()
    var loadedCountries = [Country]()
    
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    
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
        if let articleImageString = articles[indexPath.row]?.urlToImage {
            
            let forceURL = URL(string: "https://r.resimlink.com/ux_FOw48J.jpg")
            let imageURL = URL(string: articleImageString)
            cell.imageView.downloaded(from: imageURL ?? forceURL!)
//            TODO: imageview force unu kaldır!
        }
        cell.infoLabel.text = articles[indexPath.item]?.description
            return cell
        }
    }


extension HeadlinesViewController : PinterestLayoutDelegate
{
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
//        if let post = articles[indexPath.item], let photo = post.urlToImage {
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: .init(width: 177, height: 120), insideRect: boundingRect)
            
            return rect.size.height
//        }

//        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let post = articles[indexPath.item] {
            let topPadding = CGFloat(8)
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: post.description!, with: captionFont, width: width)
            let height = topPadding + captionHeight + topPadding
            
            return height
        }
        
        return 0.0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(1000.0)
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}















