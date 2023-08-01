//
//  ApiAgifyViewController.swift
//  apk ios
//
//  Created by Nabila's on 01/08/23.
//  Copyright © 2023 Nadia. All rights reserved.
//

import UIKit
import Foundation

struct AgePrediction: Codable {
    let name: String
    let age: Int
    let count: Int
}


class APIManager {
    static func getAgePrediction(name: String, completion: @escaping (AgePrediction?, Error?) -> Void) {
        let url = URL(string: "https://api.agify.io?name=\(name)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let agePrediction = try JSONDecoder().decode(AgePrediction.self, from: data)
                    completion(agePrediction, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}

class ViewController: UIViewController {

   
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    
    @IBAction func guessAgebuttonTapped(_ sender: UIButton) {
     guard let name = nameLabel.text, !name.isEmpty else {
               return
           }
           
           APIManager.getAgePrediction(name: name) { (agePrediction, error) in
               if let error = error {
                   print("Error: \(error)")
                   return
               }
               
               if let agePrediction = agePrediction {
                   DispatchQueue.main.async {
                       self.ageLabel.text = "\(agePrediction.age) tahun"
                   }
               }
           }
       }
   }

    
    
    
