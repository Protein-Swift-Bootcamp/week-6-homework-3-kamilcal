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
    
    var refreshControl = UIRefreshControl()
    
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNewsHeadlines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromStorage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        category = ""
    }
    
    func setupUI(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
    }
    
    @objc func refreshNews() {
        navigationItem.rightBarButtonItem!.isEnabled = false
        articles.removeAll()
        countriesNames.removeAll()
        collectionView.reloadData()
        requestHeadlinesForCountries(countries: loadedCountries)
    }
    
    
    //MARK: - response
    func handleHeadlineNewsResponse(articles: [Article] ,countryName: String,statusCode: Int, error: Error?) {
        if error != nil || statusCode != 200 {
            handleErrors(statusCode: statusCode,message: countryName ,error: error)
            navigationItem.rightBarButtonItem!.isEnabled = true
            return
        }
        
        navigationItem.rightBarButtonItem!.isEnabled = true
       
        for article in articles {
            if article.urlToImage != nil {
                self.articles.append(article)
                self.countriesNames.append(countryName)
            }
        }
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        collectionView.reloadData()
      
    }
    
    func setupNewsHeadlines() {
        self.refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        fetchDataFromStorage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refreshIcon"), style: .plain, target: self, action: #selector(refreshNews))
        navigationItem.rightBarButtonItem!.isEnabled = false
        
        if category.isEmpty {
            navigationItem.title = "Headlines"
            requestHeadlinesForCountries(countries: loadedCountries)
        } else {
            navigationItem.title = category
            requestHeadlinesForCountries(countries: loadedCountries)
        }
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
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HeadlinesCollectionViewCell
        if let articleImageString = articles[indexPath.row]?.urlToImage {
            
            let forceURL = URL(string: "https://r.resimlink.com/ux_FOw48J.jpg")
            let imageURL = URL(string: articleImageString)
            cell.imageView.downloaded(from: imageURL ?? forceURL!)
        }
        cell.infoLabel.text = articles[indexPath.item]?.title
        return cell
    }
}

extension HeadlinesViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var articleUrl = URL(string: (articles[indexPath.row]?.urlToImage)!)
        if let articleUrl = articleUrl {
           openUrl(articleUrl)
        } else {
            articleUrl = URL(string: articles[indexPath.row]!.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
           guard let articleUrl = articleUrl else { return }
           openUrl(articleUrl)
        }
    }
    
    func openUrl(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showError(controller: self, title: "Error", message: "Can't Open url")
        }
    }
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        return 177
        
//        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//        let rect = AVMakeRect(aspectRatio: .init(width: 177, height: 177), insideRect: boundingRect)
//
//        return rect.size.height

    }
    
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let post = articles[indexPath.item] {
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: post.title, with: captionFont, width: width)
            let height =   (captionHeight - 30 ) * 2
            
            return height
        }
        
        return 0.0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(70)
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}















