//
//  ViewController.swift
//  project7
//
//  Created by Victor Rubenko on 28.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var petitions = [Petition]()
    var filtredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(credits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(filterPetitions))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.main.async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
            }
            self?.showError()
        }
        
    }
    
    @objc func credits() {
        let vc = UIAlertController(title: "Credits", message: "Data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    @objc func filterPetitions() {
        let vc = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        vc.addTextField(configurationHandler: nil)
        vc.addAction(UIAlertAction(title: "submit", style: .default) {
            [weak self, weak vc] _ in
            guard let filterString = vc?.textFields?[0].text else { return }
            let terms = filterString.components(separatedBy: " ").map { $0.lowercased() }
            self?.filtredPetitions = [Petition]()
            for petition in self!.petitions {
                for term in terms {
                    if petition.title.lowercased().contains(term) {
                        self?.filtredPetitions.append(petition)
                        continue
                    }
                }
            }
            self?.tableView.reloadData()
        }
        )
        present(vc, animated: true, completion: nil)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filtredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredPetitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petitionCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1) \(filtredPetitions[indexPath.row].title)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filtredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func showError() {
        let vc = UIAlertController(title: "Loading Error", message: nil, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(vc, animated: true, completion: nil)
    }

}

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

