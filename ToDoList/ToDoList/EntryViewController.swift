//
//  EntryViewController.swift
//  ToDoList
//
//  Created by Victor Rubenko on 05.01.2021.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var task_title: UITextField!
    @IBOutlet var task_text: UITextView!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        task_title.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    @objc func saveTask() {
        
        guard let title = task_title.text, !title.isEmpty else {
            return
        }
        
        guard let text = task_text.text, !text.isEmpty else {
            return
        }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let task = Task(title: title, text: text)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(task) {
            UserDefaults().set(count + 1, forKey: "count")
            UserDefaults().set(encoded, forKey: "task_\(count + 1)")
        }
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }

}
