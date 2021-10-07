//
//  ApiService.swift
//  Movie
//
//  Created by Osadchuk Taras on 29.08.2021.
//

import Foundation

class ApiService {
    private var dataTask: URLSessionDataTask?
    
    //MARK: - Get popular movies data
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        
        let popularMovieURL = "https://api.themoviedb.org/3/movie/popular?api_key=b4c76d2e345b90c91ceb38b964d4087f&language=en-US&page=1"
        
        guard let url = URL(string: popularMovieURL) else {return}
        
        //Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response,error) in
            //Hendle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                //Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                //Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                //Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                //Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
                
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    //MARK: - Get image data
    func getImageDataFrom(url:URL, completion: @escaping ((Data) -> Void)) {
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //Handle Error
            if let error = error{
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                //Handle Empty data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
