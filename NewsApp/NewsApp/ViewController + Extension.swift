//
//  ViewController + Extension.swift
//  NewsApp
//
//  Created by kamilcal on 12.01.2023.
//

import Foundation
import UIKit

// A ui view controller extension that contains behavior shared across all app view controllers
extension UIViewController : UICollectionViewDelegate {
    
    // MARK: Helper Methods
    
    // A helper method to handle different errors
    func handleErrors(statusCode: Int,message: String ,error: Error?) {
        switch statusCode {
            // News Api Errors
        case 1 : showError(controller: self, title: "Error", message: message)
            
            // Http Errors
        case 400: showError(controller: self, title: "Bad Request", message: "The request was unacceptable, often due to a missing or misconfigured parameter")
        case 401: showError(controller: self, title: "Unauthorized", message: "Your API key was missing from the request, or wasn't correct")
        case 429: showError(controller: self, title: "Too Many Requests", message: "You made too many requests within a window of time and have been rate limited")
        case 404: showError(controller: self, title: "Error", message: "File Not Found")
        case 500: showError(controller: self, title: "Server Error", message: "Something went wrong on our side")
        default:  showError(controller: self,title: "Error", message: error?.localizedDescription ?? "")
        }
    }
    // A helper method that shows an Alert Box containing a given message
    func showError(controller: UIViewController, title: String,message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
    }
}
