//
//  NoteViewController.swift
//  FocusStart-Notes
//
//  Created by Ермоленко Константин on 17.03.2021.
//

import UIKit

class NoteViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - Public properties
    
    var note: Note?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            titleLabel.text = note.title
            contentTextView.text = note.content
        }
        
        titleLabel.delegate = self
        
        setupHideKeyboardOnTap()
    }
    
    // MARK: - IB Actions
    
    @IBAction func cancelNote() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveNote() {
        let note = CoreDataManager.newNote()
        note.title = titleLabel.text ?? ""
        note.content = contentTextView.text ?? ""
        CoreDataManager.saveNote()
        
        navigationController?.popViewController(animated: true)
    }
}

extension NoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextField = textField.superview?.viewWithTag(nextTag) as? UITextView {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension UIViewController {
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(
            target: self.view,
            action: #selector(self.view.endEditing(_:))
        )
        tap.cancelsTouchesInView = false
        
        return tap
    }
}
