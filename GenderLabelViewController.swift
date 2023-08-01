//
//  GenderLabelViewController.swift
//  apk ios
//
//  Created by Nabila's on 01/08/23.
//  Copyright © 2023 Nadia. All rights reserved.
//
import UIKit
import Foundation

class GenderLabelViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func guessGenderButtonTapped(_ sender: UIButton) {
        if let name = nameTextField.text, !name.isEmpty {
            getGenderFromAPI(name: name)
        } else {
            genderLabel.text = "Masukkan nama terlebih dahulu."
        }
    }
    
    func getGenderFromAPI(name: String) {
        if let url = URL(string: "https://api.genderize.io/?name=\(name)") {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let gender = json?["gender"] as? String {
                            DispatchQueue.main.async {
                                self.updateGenderLabel(gender: gender)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.genderLabel.text = "Tidak dapat menebak gender."
                            }
                        }
                    } catch {
                        print("JSON Error: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func updateGenderLabel(gender: String) {
        genderLabel.text = "Gender: \(gender.capitalized)"
    }
}

