//
//  SplashScreenViewControler.swift
//  Movie
//
//  Created by Osadchuk Taras on 29.08.2021.
//

import UIKit

class SplashScreenViewControler: UIViewController {
    
    private var apiService = ApiService()

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            loadPopularMoviesData()
        }
    
    private func loadPopularMoviesData() {
        //fetch data from server
        apiService.getPopularMoviesData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                //Save Data to Core Data
                CoreData.sharedInstance.saveDataOf(movies: listOf.movies)
                self?.perform(#selector(self?.mainScreen))
                
            case .failure(let error):
                //Show alert message in case of error
                self?.showAlertWith(title: "Cloud Not Connect!", message: "Please check your internet connection \n or try again later")
                //Somthing is wrong with the JSON file or the model
            print("Error processing json data: \(error)")
                
            }
        }
    }
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    
    //Perform a transition to the main screen (MovieListViewControler
    
    @objc func mainScreen() {
        performSegue(withIdentifier: "moviesList", sender: self)
    }

}

