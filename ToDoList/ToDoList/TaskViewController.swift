//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Victor Rubenko on 05.01.2021.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    var task: Task?
    var currentPosition: Int?
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = task?.text
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        self.updateUserDefaults(count: count, currentPosition: currentPosition!)
        
        UserDefaults().set(count - 1, forKey: "count")
        UserDefaults().set(nil, forKey: "task_\(String(describing: count))")
        
        update?()
     
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateUserDefaults(count: Int, currentPosition: Int) {
        var x = 0
        for i in 0...count{
            if i == currentPosition {
                continue
            }
            
            UserDefaults().set(UserDefaults().object(forKey: "task_\(i+1)"), forKey: "task_\(x+1)")
            
            x += 1
        }
    }
    
}
