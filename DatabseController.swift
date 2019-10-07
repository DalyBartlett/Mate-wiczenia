import Foundation
import CoreData
class DatabaseController
{
    static var questions = [Int]()
    private init() {
    }
    class func getContext() -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "500squarerootmath")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    class func clearCoreDataStore() {
        let entities = DatabaseController.persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                deleteRequest.resultType = NSBatchDeleteRequestResultType.resultTypeObjectIDs
                let result = try DatabaseController.getContext().execute(deleteRequest) as? NSBatchDeleteResult
                let objectIDArray = result?.result as? [NSManagedObjectID]
                let changes = [NSDeletedObjectsKey : objectIDArray]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [DatabaseController.getContext()])
            } catch {
                print(error)
            }
            DatabaseController.saveContext()
        }
    }
    class func saveToCoreData(entityName: String , questions: [Int]) {
        if entityName == "Algebra" {
            let choosenEntity: Algebra = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Algebra
            choosenEntity.questions = questions
        } else if entityName == "Funkcje" {
            let choosenEntity: Funkcje = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Funkcje
            choosenEntity.questions = questions
        } else if entityName == "Trygonometria" {
            let choosenEntity: Trygonometria = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Trygonometria
            choosenEntity.questions = questions
        } else if entityName == "Geometria" {
            let choosenEntity: Geometria = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Geometria
            choosenEntity.questions = questions
        } else if entityName == "Prawdopodobienstwo" {
            let choosenEntity: Prawdopodobienstwo = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Prawdopodobienstwo
            choosenEntity.questions = questions
        }
        DatabaseController.saveContext()
    }
    class func saveTimerToCoreData(entityName: String , timer: Int16) {
        if entityName == "Algebra" {
            let choosenEntity: Algebra = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Algebra
            choosenEntity.czasOdp = timer
        } else if entityName == "Funkcje" {
            let choosenEntity: Funkcje = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Funkcje
            choosenEntity.czasOdp = timer
        } else if entityName == "Trygonomatria" {
            let choosenEntity: Trygonometria = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Trygonometria
            choosenEntity.czasOdp = timer
        } else if entityName == "Geometria" {
            let choosenEntity: Geometria = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Geometria
            choosenEntity.czasOdp = timer
        } else if entityName == "Prawdopodobienstwo" {
            let choosenEntity: Prawdopodobienstwo = NSEntityDescription.insertNewObject(forEntityName: entityName, into: DatabaseController.getContext()) as! Prawdopodobienstwo
            choosenEntity.czasOdp = timer
        }
        DatabaseController.saveContext()
    }
}
extension Algebra {
    class func instance(with name: String) -> Algebra? {
        let request: NSFetchRequest<Algebra> = Algebra.fetchRequest()
        let predicate = NSPredicate(format: "czasOdp = %@", name)
        request.predicate = predicate
        do {
            let tasks = try DatabaseController.getContext().fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    func updatequestions(with questions: [Int]) {
        self.questions = questions
        DatabaseController.saveContext()
    }
    func delete() {
        DatabaseController.getContext().delete(self)
        DatabaseController.saveContext()
    }
}
extension Funkcje {
    class func instance(with name: String) -> Funkcje? {
        let request: NSFetchRequest<Funkcje> = Funkcje.fetchRequest()
        let predicate = NSPredicate(format: "czasOdp = %@", name)
        request.predicate = predicate
        do {
            let tasks = try DatabaseController.getContext().fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    func updatequestions(with questions: [Int]) {
        self.questions = questions
        DatabaseController.saveContext()
    }
    func delete() {
        DatabaseController.getContext().delete(self)
        DatabaseController.saveContext()
    }
}
extension Trygonometria {
    class func instance(with name: String) -> Trygonometria? {
        let request: NSFetchRequest<Trygonometria> = Trygonometria.fetchRequest()
        let predicate = NSPredicate(format: "czasOdp = %@", name)
        request.predicate = predicate
        do {
            let tasks = try DatabaseController.getContext().fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    func updatequestions(with questions: [Int]) {
        self.questions = questions
        DatabaseController.saveContext()
    }
    func delete() {
        DatabaseController.getContext().delete(self)
        DatabaseController.saveContext()
    }
}
extension Geometria {
    class func instance(with name: String) -> Geometria? {
        let request: NSFetchRequest<Geometria> = Geometria.fetchRequest()
        let predicate = NSPredicate(format: "czasOdp = %@", name)
        request.predicate = predicate
        do {
            let tasks = try DatabaseController.getContext().fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    func updatequestions(with questions: [Int]) {
        self.questions = questions
        DatabaseController.saveContext()
    }
    func delete() {
        DatabaseController.getContext().delete(self)
        DatabaseController.saveContext()
    }
}
extension Prawdopodobienstwo {
    class func instance(with name: String) -> Prawdopodobienstwo? {
        let request: NSFetchRequest<Prawdopodobienstwo> = Prawdopodobienstwo.fetchRequest()
        let predicate = NSPredicate(format: "czasOdp = %@", name)
        request.predicate = predicate
        do {
            let tasks = try DatabaseController.getContext().fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    func updatequestions(with questions: [Int]) {
        self.questions = questions
        DatabaseController.saveContext()
    }
    func delete() {
        DatabaseController.getContext().delete(self)
        DatabaseController.saveContext()
    }
}
