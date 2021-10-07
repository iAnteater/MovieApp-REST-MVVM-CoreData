//
//  CoreData.swift
//  Movie
//
//  Created by Osadchuk Taras on 30.08.2021.
//

import UIKit
import CoreData

class CoreData {
    static let sharedInstance = CoreData()
        private init(){}
        
        private let continer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        private let fetchRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    func saveDataOf(movies:[Movie]){
        //updates CoreData
        self.continer?.performBackgroundTask{ [weak self] (context) in
            self?.deleteObjectsCoreData(context: context)
            self?.saveDataToCoreData(movies: movies, context: context)
        }
    }
    
    //MARK: - Delete Core Data objects before saving new data
    private func deleteObjectsCoreData(context: NSManagedObjectContext) {
        do{
            //Fetch Data
            let objects = try context.fetch(fetchRequest)
            
            //Delete Data
            _ = objects.map({context.delete($0)})
            
            //Save Data
            try context.save()
        }catch{
            print("Delete Error: \(error)")
        }
    }
    
    private func saveDataToCoreData( movies:[Movie], context: NSManagedObjectContext){
        
        context.perform {
           
            for movie in movies{
                let movieEntity = MovieEntity (context: context)
                movieEntity.title = movie.title
                movieEntity.year = movie.year
                guard let rate = movie .rate else {return}
                movieEntity.rate = String(rate)
                movieEntity.posterImage = movie.posterImage
                movieEntity.backdropImage = movie.backdropImage
                movieEntity.overview = movie.overview
                
            }
            do {
                try context.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
            
        }
    }
}
