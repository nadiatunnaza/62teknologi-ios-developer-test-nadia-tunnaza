//
//  PetsPredictViewController.swift
//  apk ios
//
//  Created by Nabila's on 01/08/23.
//  Copyright © 2023 Nadia. All rights reserved.
//

import UIKit

struct DogImage: Codable {
    let message: String
}

class PetsPredictViewController: UIViewController {

    
    @IBOutlet weak var dogImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomDogImage()
    }
    @IBAction func fetchButtonTapped(_ sender: Any) {
        getRandomDogImage()
    }

    func getRandomDogImage() {
        let apiUrlString = "https://dog.ceo/api/breeds/image/random"

        guard let apiUrl = URL(string: apiUrlString) else {
            print("Invalid API URL")
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let dogImage = try decoder.decode(DogImage.self, from: data)
                    self.loadDogImage(urlString: dogImage.message)
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }

        task.resume()
    }

    func loadDogImage(urlString: String) {
        guard let imageUrl = URL(string: urlString) else {
            print("Invalid image URL")
            return
        }

        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async { [weak self] in
                    self?.dogImageView.image = image
                }
            }
        }
    }
}
