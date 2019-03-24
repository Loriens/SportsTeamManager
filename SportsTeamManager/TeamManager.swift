//
//  TeamManager.swift
//  SportsTeamManager
//
//  Created by Vladislav on 18/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import CoreData

final class TeamManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(error), \(nserror.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject> (from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        
        return object
    }
    
    func delete(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
        save(context: context)
    }
    
    func fetchData<T: NSManagedObject> (from entity: T.Type, predicate: NSCompoundPredicate? = nil) -> [T] {
        let context = getContext()
        
        let request: NSFetchRequest<T>
        var fetchResult = [T]()
        
//        let sortDescriptor = NSSortDescriptor(key: "fullName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request = entity.fetchRequest() as! NSFetchRequest<T>
        request.predicate = predicate
//        request.sortDescriptors = [sortDescriptor]
        
        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        
        return fetchResult
    }
    
    func fetchDataWithController<T: NSManagedObject>(for entity: T.Type, sectionNameKeyPath: String? = nil, predicate: NSCompoundPredicate? = nil) -> NSFetchedResultsController<T> {
        let context = getContext()
        let request = entity.fetchRequest() as! NSFetchRequest<T>
        
        let sortDescriptor = NSSortDescriptor(key: "player.position", ascending: true)
        //
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        
        return controller
    }
    
}
