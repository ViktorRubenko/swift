//
//  ViewController.swift
//  ToDoList
//
//  Created by Victor Rubenko on 05.01.2021.
//

import UIKit


struct Task: Codable {
    var title: String?
    var text: String?
}

class ViewController: UIViewController {
    
    var tasks: [Task] = []

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        updateTasks()
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }

        let decoder = JSONDecoder()
        for i in 0..<count {
            if let task = UserDefaults().object(forKey: "task_\(i+1)") as? Data {
                if let decodedTask = try? decoder.decode(Task.self, from: task) {
                    tasks.append(Task(title: decodedTask.title, text: decodedTask.text))
                }
            }
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func didTapAdd() {
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.task = tasks[indexPath.row]
        vc.title = tasks[indexPath.row].title
        vc.currentPosition = indexPath.row
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title
        
        return cell
    }
}
