//
//  MovieDatailsViewController.swift
//  Movie
//
//  Created by Osadchuk Taras on 01.09.2021.
//

import UIKit

class MovieDatailsViewController: UIViewController {
    
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseData: UILabel!
    
    var viewModel: MovieDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        updateUI()

    }
    
    private func updateUI(){
        self.movieTitle.text = viewModel.title
        self.movieRate.text = viewModel.rate
        self.movieReleaseData.text = viewModel.year
        self.movieOverview.text = viewModel.overview
        self.moviePoster.setImageFromPath(viewModel.posterImage)
        viewAttributes()
        
    }

    //MARK: - View attributes
    private func viewAttributes() {
        movieRate.layer.masksToBounds = true
        movieRate.layer.cornerRadius = 15
    }

}

extension UIImageView {
    func setImageFromPath(_ path: String?) {
        image = nil
        DispatchQueue.global(qos: .background).async {
            var image: UIImage?
            guard let imagePath = path else {return}
            if let imageURL = URL(string: imagePath) {
                if let imageData = NSData(contentsOf: imageURL) {
                    image = UIImage(data: imageData as Data)
                } else {
                    // Image default - In case of error
                    image = UIImage(named: "noImageAvailable")
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
