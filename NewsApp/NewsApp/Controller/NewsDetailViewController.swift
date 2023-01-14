//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by kamilcal on 13.01.2023.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var publishedDataLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    var articles = [Article?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
//        setData
        private func setData() {
            guard articles != nil else { return }
            
            descriptionLabel.text = articles.description
            
        }
    
}
