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
        configureKeyboard()
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
        
    // MARK: - Private methods
    
    private func configureKeyboard() {
        setupHideKeyboardOnTap()
        configureAccessoryToolBar()
    }
    
    private func configureAccessoryToolBar() {
        let accessoryToolBar = UIToolbar(
            frame: CGRect(x: 0,
                          y: 0,
                          width: UIScreen.main.bounds.width,
                          height: 44)
        )
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let accessoryDoneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self, action: #selector(self.donePressed)
        )
        accessoryToolBar.items = [spacer, accessoryDoneButton]
        
        titleLabel.inputAccessoryView = accessoryToolBar
        contentTextView.inputAccessoryView = accessoryToolBar
    }

    @objc func donePressed() {
        view.endEditing(true)
    }
    
    private func setupHideKeyboardOnTap() {
        titleLabel.delegate = self

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
