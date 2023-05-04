//
//  TableViewController.swift
//  Projects28-30_100days
//
//  Created by user228564 on 5/3/23.
//

import UIKit
import LocalAuthentication

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var secret: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var keyValuePairs = [String: String]()
    var addPairButton: UIBarButtonItem!
    var passDictionaryBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Locked"
        
        DispatchQueue.global(qos: .background).async {
            if let data = UserDefaults.standard.object(forKey: "myDictionary") as? Data {
                if (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String]) != nil {
                }
            }
        }
        
        // Setup table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Setup left navigation bar button
        addPairButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addKeyValuePair))
        navigationItem.leftBarButtonItem = addPairButton
        
        // Setup right navigation bar button
        passDictionaryBarButton = UIBarButtonItem(title: "To game", style: .plain, target: self, action: #selector(passDictionary))
        navigationItem.rightBarButtonItem = passDictionaryBarButton
        
        addPairButton.isHidden = true
        passDictionaryBarButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    
    // MARK: - Keychain
    
    @IBAction func unlockTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecret()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                        
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func unlockSecret() {
        tableView.isHidden = false
        addPairButton.isHidden = false
        passDictionaryBarButton.isHidden = false
        title = "Unlocked"
    }
    
    func lockSecret() {
        tableView.isHidden = true
        addPairButton.isHidden = true
        passDictionaryBarButton.isHidden = true
        title = "Locked"
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyValuePairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = Array(keyValuePairs.keys)[indexPath.row]
        let value = Array(keyValuePairs.values)[indexPath.row]
        cell.textLabel?.text = "\(key)  ->  \(value)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(keyValuePairs.keys)[indexPath.row]
        let value = keyValuePairs[key]
        
        // Show an alert with two text fields to allow the user to edit the key and value
        let ac = UIAlertController(title: "Edit Key and Value", message: "Enter a new key and value for the entry:", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Key"
            textField.text = key
        }
        ac.addTextField { textField in
            textField.placeholder = "Value"
            textField.text = value
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let newKey = ac.textFields?.first?.text, let newValue = ac.textFields?.last?.text {
                if newKey != key {
                    // If the key has changed, remove the old key-value pair and add a new one
                    self.keyValuePairs[newKey] = self.keyValuePairs.removeValue(forKey: key)
                }
                self.keyValuePairs[newKey] = newValue
                tableView.reloadData()
            }
        }
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        present(ac, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the key-value pair for this row
            let key = Array(keyValuePairs.keys)[indexPath.row]
            keyValuePairs.removeValue(forKey: key)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Actions
    
    @objc func addKeyValuePair() {
        if keyValuePairs.count >= 18 {
            let ac = UIAlertController(title: "The dictionary is full!", message: "Please, modify or delete existing entries", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(okAction)
            present(ac, animated: true, completion: nil)
            return
        }
            
            
        let ac = UIAlertController(title: "Add Country-Capital Pair", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Country"
        })
        ac.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Capital"
        })
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            guard let key = ac.textFields?[0].text, let value = ac.textFields?[1].text else { return }
    
            self?.keyValuePairs[key] = value
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(addAction)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func passDictionary() {
        saveDataDict(dicToWrite: keyValuePairs)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.dataDict = keyValuePairs
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDataDict(dicToWrite: keyValuePairs)
        
    }
        
    @objc func applicationDidEnterBackground() {
        saveDataDict(dicToWrite: keyValuePairs)
        lockSecret()
    }
        
    @objc func applicationWillTerminate() {
        saveDataDict(dicToWrite: keyValuePairs)
        lockSecret()
    }
        
    
    func saveDataDict(dicToWrite: [String: String]) {
        // Convert the dictionary to a Data object using NSKeyedArchiver
        let data = try! NSKeyedArchiver.archivedData(withRootObject: dicToWrite, requiringSecureCoding: false)

        // Save the Data object to UserDefaults
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.set(data, forKey: "myDictionary")
        }
    }
    

}
