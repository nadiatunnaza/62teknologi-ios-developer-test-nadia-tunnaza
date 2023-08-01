//
//  UniversityViewController.swift
//  apk ios
//
//  Created by Nabila's on 31/07/23.
//  Copyright © 2023 Nadia. All rights reserved.
//

import UIKit

struct University: Codable {
    let name: String
}

class UniversityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var universities: [University] = []
    var filteredUniversities: [University] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        fetchUniversities()
    }
    
    func fetchUniversities() {
        let url = URL(string: "http://universities.hipolabs.com/search?country=indonesia")!
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self?.universities = try decoder.decode([University].self, from: data)
                self?.filteredUniversities = self?.universities ?? []
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension UniversityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUniversities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath)
        cell.textLabel?.text = filteredUniversities[indexPath.row].name
        return cell
    }
}

extension UniversityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUniversities = universities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
