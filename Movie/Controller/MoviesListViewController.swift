//
//  MoviesListViewController.swift
//  Movie
//
//  Created by Osadchuk Taras on 31.08.2021.
//

import UIKit
import CoreData

class MoviesListViewController: UIViewController, UpdateTableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = MoviesListViewModael()
    
    override func viewDidLoad() {
            super.viewDidLoad()

            setNavigationBar()
            self.tableView.dataSource = self
            self.viewModel.delegate = self
            loadData()
        }
        
        private func loadData() {
            viewModel.retrieveDataFromCoreData()
        }
        
        // Update the tableView if changes have been made
        func reloadData(sender: MoviesListViewModael) {
            self.tableView.reloadData()
        }
        
        // MARK: - Navigation - a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "movieSelected" {
                guard let detailsVC = segue.destination as? MovieDatailsViewController else {return}
                guard let selectedMovieCell = sender as? UITableViewCell else {return}
                
                if let indexPath = tableView.indexPath(for: selectedMovieCell) {
                    let selectedMovie = viewModel.object(indexPath: indexPath)
                    detailsVC.viewModel = MovieDetailsViewModel(movieDetails: selectedMovie)
                }
                // Back button without title on the next screen
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
        }
        
        //MARK: - Navigation Bar appearance
        private func setNavigationBar() {
            // Transparent the navigation bar
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            // Navigation bar item color (time, battery) - white
            self.navigationController?.navigationBar.barStyle = .black
        }
    }

    //MARK: - TableView
    extension MoviesListViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfRowsInSection(section: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let object = viewModel.object(indexPath: indexPath)
            
            if let movieCell = cell as? MovieListTableViewCell {
                if let movie = object {
                    movieCell.setCellWithValuesOf(movie)
                }
            }
            return cell
        }
    }
