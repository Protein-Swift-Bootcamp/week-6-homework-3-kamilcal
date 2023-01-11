//
//  CountrySelectionViewController.swift
//  NewsApp
//
//  Created by kamilcal on 10.01.2023.
//

import UIKit
import CoreData

class CountrySelectionViewController: UIViewController {

    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    
    var dataController = DataController.shared
    
    var countries = [String]()
    var selectedCountries = [String]()
    var loadedCountries = [Country]()
    
    var isEditingCountries = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelectionTable()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? dataController.viewContext.save()
    }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        for currentCountry in selectedCountries {
            let country = Country(context: dataController.viewContext)
            country.country = currentCountry
            countries.append(country.country!)
        }
        guard selectedCountries.count == 0 else {
            performSegue(withIdentifier: "GetStarted", sender: self)
//            TODO: present e çevir, alert ekle.
            return
        }
    }
    

}

//MARK: - UITableViewDelegate - UITableViewDataSource

extension CountrySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        let countryName = countries[indexPath.row]
        cell.textLabel?.text = countryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountries.append(countries[indexPath.row])
        print("\(selectedCountries)")
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedCountries.remove(at: selectedCountries.firstIndex(of: countries[indexPath.row])!)
        print("\(selectedCountries)")
    }
    //MARK: - setupSelectionTable

    func setupSelectionTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            loadedCountries = result
            countries = Countries.allCases.map {$0.rawValue}
            for loadedCountry in loadedCountries {
                selectedCountries.append(loadedCountry.country!)
            }
            countries = countries.filter{ !selectedCountries.contains($0)}
            selectedCountries.removeAll()
            tableView.reloadData()
            
        }
        
        
    }
}
