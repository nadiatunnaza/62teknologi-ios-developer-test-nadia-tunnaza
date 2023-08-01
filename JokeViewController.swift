//
//  JokeViewController.swift
//  apk ios
//
//  Created by Nabila's on 01/08/23.
//  Copyright © 2023 Nadia. All rights reserved.
//

import UIKit
import Foundation

struct Joke: Codable {
    let setup: String
    let punchline: String
}

class JokeAPI {
    static func fetchJoke(completion: @escaping (Result<Joke, Error>) -> Void) {
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_joke") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                completion(.success(joke))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


class JokeViewController: UIViewController {
    
    @IBOutlet weak var jokeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        jokeLabel.text = "Press the button to get a joke!"
    }

    @IBAction func getJokeButtonTapped(_ sender: UIButton) {JokeAPI.fetchJoke { [weak self] result in
        switch result {
        case .success(let joke):
            DispatchQueue.main.async {
                self?.jokeLabel.text = "\(joke.setup)\n\(joke.punchline)"
            }
        case .failure(let error):
            print("Error fetching joke: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self?.jokeLabel.text = "Failed to get joke."
    }
            }
        }
    }
}

