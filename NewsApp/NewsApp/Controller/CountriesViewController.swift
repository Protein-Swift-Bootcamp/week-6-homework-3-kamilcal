//
//  CountriesViewController.swift
//  NewsApp
//
//  Created by kamilcal on 10.01.2023.
//

import UIKit
import CoreData

class CountriesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var countries = [Country]()
    var loadedCountries = [Country]()
    var dataController = DataController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableCountries()
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var controller = CountrySelectionViewController()
        controller = storyboard?.instantiateViewController(withIdentifier: "CountrySelectionController") as! CountrySelectionViewController
        controller.isEditingCountries = true
        present(controller,animated: true,completion: nil)
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if self.tableView.isEditing != true {
            changeTableEditingState(state: true, title: "Done")
        }
        else {
            changeTableEditingState(state: false, title: "Edit")
        }
    }
    
    func changeTableEditingState(state: Bool,title: String){
        self.tableView.isEditing = state
        self.navigationItem.leftBarButtonItem?.title = title
    }
    func reloadTableCountries() {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            countries = result
        }
        self.tableView.reloadData()
   }
}

extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        let countryName = countries[indexPath.row]
        cell.textLabel?.text = countryName.country
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
  
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    // Handle when a country is deleted and save changes
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if countries.count > 1 {
                let countryToDelete = countries[indexPath.row]
                dataController.viewContext.delete(countryToDelete)
                if dataController.viewContext.hasChanges {
                    try? dataController.viewContext.save()
                }
                countries.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                showError(controller: self, title: "", message: "You must have at least 1 Country Selected")
                changeTableEditingState(state: false, title: "Edit")
            }
        }
    }
}

