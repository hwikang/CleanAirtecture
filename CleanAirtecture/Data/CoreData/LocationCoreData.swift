//
//  LocationCoreData.swift
//  CleanAirtecture
//
//  Created by paytalab on 7/2/24.
//

import Foundation
import CoreData


final public class LocationCoreData {
    private let viewContext: NSManagedObjectContext
    
    public init(viewContext: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.viewContext = viewContext
    }
    
    public func saveLocation(location: Location) -> Result<Void, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "SavedLocation", in: viewContext) else {
            return .failure(CoreDataError.entityNotFound("SavedLocation"))}
        
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(location.latitude, forKey: "latitude")
        userObject.setValue(location.longitude, forKey: "longitude")
        userObject.setValue(location.name, forKey: "name")
        userObject.setValue(location.nickname, forKey: "nickname")
        
        do {
            try viewContext.save()
        } catch let error {
            return .failure(CoreDataError.saveError(error.localizedDescription))
            
        }
        return .success(())
    }
    
    public func getSavedLocations() -> Result<[Location], CoreDataError>  {
        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let locations: [Location] = result.compactMap { location in
                guard let name = location.name else { return nil }
                return Location(latitude: location.latitude, longitude: location.longitude, name: name, nickname: location.nickname)
            }
            return .success(locations)
        } catch let error {
            return .failure(CoreDataError.readError(error.localizedDescription))
        }
    }
    
    public func getLocation(latitude: Double, longitude: Double) -> Result<Location?, CoreDataError> {
  
        do {
            let location = try getSavedLocation(latitude: latitude, longitude: longitude)
            
            guard let location = location, let name = location.name else { return .success(nil) }
            return .success(Location(latitude: location.latitude, longitude: location.longitude, name: name, nickname: location.nickname))
            
        } catch let error as NSError {
            print("Fetching error: \(error)")
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    public func updateLocation(latitude: Double, longitude: Double, nickname: String) -> Result<Bool, CoreDataError> {
        
        do {
            let location = try getSavedLocation(latitude: latitude, longitude: longitude)
            guard let location = location else { return .success(false) }
            location.nickname = nickname
            try viewContext.save()
            return .success(true)
        } catch let error as NSError {
            print("Error updating nickname: \(error)")
            return .failure(.updateError(error.localizedDescription))
        }
    }
    
    private func getSavedLocation(latitude: Double, longitude: Double) throws -> SavedLocation? {
        let fetchRequest: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf", latitude, longitude)
        fetchRequest.predicate = predicate
        
        let results = try viewContext.fetch(fetchRequest)
        return results.first
    }
}
    
