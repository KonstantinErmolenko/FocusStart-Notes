//
//  MainViewController.swift
//  FocusStart-Notes
//
//  Created by Ермоленко Константин on 17.03.2021.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    // MARK: - Public properties

    var notes: [Note] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notes = CoreDataManager.fetchNotes()
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNote" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let note = notes[indexPath.row]
            let destination = segue.destination as! NoteViewController
            destination.note = note
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.value(forKeyPath: "title") as? String
        
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "EditNote", sender: note)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = notes[indexPath.row]
            CoreDataManager.delete(note: noteToDelete)
            notes = CoreDataManager.fetchNotes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
