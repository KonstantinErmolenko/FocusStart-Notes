//
//  CoreDataManager.swift
//  FocusStart-Notes
//
//  Created by Ермоленко Константин on 17.03.2021.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(
            forEntityName: "Note",
            into: context
        ) as! Note
        
        return note
    }
    
    static func fetchNotes() -> [Note] {
        do {
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            let results = try context.fetch(fetchRequest)
            
            return results
            
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(note: Note) {
        context.delete(note)
        saveNote()
    }

    static func createDemoNote() {
        let note = CoreDataManager.newNote()
        note.title = "Добро пожаловать!"
        note.content = "С помощью данного приложения можно сохранять интересные мысли и идеи."
        CoreDataManager.saveNote()
    }
}
