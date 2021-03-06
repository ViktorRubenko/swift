//
//  ViewController.swift
//  project10
//
//  Created by Victor Rubenko on 03.03.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Names to Faces"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            if let decodedPeople = try? jsonDecoder.decode([Person].self, from: savedPeople) {
                people = decodedPeople
            } else {
                print("Failed to load people.")
            }
        }
        
    }
    
    @objc func addNewPerson() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ac = UIAlertController(title: "Add new image", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Make photo", style: .default) { [weak self] _ in
                self!.addNewImage(.camera)
            })
            ac.addAction(UIAlertAction(title: "From Library", style: .default) { [weak self] _ in
                self!.addNewImage()
            })
            present(ac, animated: true)
        } else {
            addNewImage()
        }
    }
    
    func addNewImage(_ sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDir().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        save()
        
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self, weak cell] in
            if let person = self?.people[indexPath.row] {
                if let image = UIImage(contentsOfFile: self!.getDocumentsDir().appendingPathComponent(person.image).path) {
                    DispatchQueue.main.async {
                        cell?.name.text = person.name
                        cell?.imageView.image = image
                        cell?.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                        cell?.imageView.layer.borderWidth = 2
                        cell?.imageView.layer.cornerRadius = 3
                        cell?.layer.cornerRadius = 5
                    }
                }
            }
            
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        let ac = UIAlertController(title: "Edit person", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: nil)
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let name = ac?.textFields?[0].text else { return }
                person.name = name
                self!.save()
                self?.collectionView.reloadData()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self!.present(ac, animated: true, completion: nil)
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self!.people.remove(at: indexPath.row)
            self!.save()
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true, completion: nil)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
}

