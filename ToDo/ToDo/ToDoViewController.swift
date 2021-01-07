//
//  ViewController.swift
//  ToDo
//
//  Created by Dhiva Krishna on 1/4/21.
//

import UIKit

class ToDoViewController: UITableViewController{
    
    var items: [String] = []
    //Persistant data storage for databases
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Search for the file based off the key
        if let storedItems = defaults.array(forKey: "ToDoListArray") as? [String] {
            items = storedItems
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //as! UITableViewCell
        //if we get errors later with the cells just force unwrap them
        
        //Use internal indexPath var to get indecies and populate data
        toDoItem.textLabel?.text = items[indexPath.row]
        return toDoItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
        //print(items[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textFieldExt = UITextField()
        
        let alert = UIAlertController(title: "Add new item?", message: "", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Add something new to do bru!"
            //Assign external textfield to this internal textfield in the alert
            textFieldExt = textField
            
        }
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: {(action) in
            
            
            if !textFieldExt.text!.isEmpty {
                print(textFieldExt.text ?? "Empty, nothing entered")
                self.items.append(textFieldExt.text!)
                
                //Persistant store in the array so we don't lose data upon termination
                self.defaults.set(self.items, forKey: "ToDoListArray")
                
                self.tableView.reloadData()
            } else {
                print("Is empty")
            }
           
        }))
       
        
        self.present(alert, animated: true)
    }
    
    
}



