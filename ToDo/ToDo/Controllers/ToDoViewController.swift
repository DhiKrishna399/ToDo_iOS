//
//  ViewController.swift
//  ToDo
//
//  Created by Dhiva Krishna on 1/4/21.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController{
    
    var items: [Item] = []
    
    //    //File Path for storing data into a PList
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Access to CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        loadItems()
        
        
        //Search for the file based off the key
        //        if let storedItems = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            items = storedItems
        //        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //as! UITableViewCell
        //if we get errors later with the cells just force unwrap them
        
        //Use internal indexPath var to get indecies and populate data
        //Set the text of the cell to be the title of the item in the items array
        toDoItem.textLabel?.text = items[indexPath.row].title
        
        toDoItem.accessoryType = items[indexPath.row].itemDone == true ? .checkmark : .none
        
        return toDoItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Toggle the itemDone variable in each item
        items[indexPath.row].itemDone = !items[indexPath.row].itemDone
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textFieldExt = UITextField()
        
        let alert = UIAlertController(title: "Add new item?", message: "", preferredStyle: .alert)
        
        //Add a textField to the alert and attach it to an external textfield
        alert.addTextField{ (textField) in
            textField.placeholder = "Add something new to do bru!"
            //Assign external textfield to this internal textfield in the alert
            textFieldExt = textField
            
        }
        
        //Action for when add item is pressed
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: {(action) in
            
            //Create a temp item and append it to our array of items
            if !textFieldExt.text!.isEmpty {
                print(textFieldExt.text ?? "Empty, nothing entered")
                
                
                
                //This is created using an NSManagedObject from our core DataModel
                //We must fill in title anditemDone fields bc we said they can't be optional values
                let temp = Item(context: self.context)
                temp.title = textFieldExt.text!
                temp.itemDone = false
                
                self.items.append(temp)
                
                self.saveItems()
            } else {
                print("Is empty")
            }
            
        }))
        
        
        self.present(alert, animated: true)
    }
    
    func saveItems(){
        //Persistant store in the array so we don't lose data upon termination
        // self.defaults.set(self.items, forKey: "ToDoListArray")
        
        do {
            try context.save()
        }catch {
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //    func loadItems(){
    //
    //
    //        if let data = try? Data(contentsOf: dataFilePath!){
    //            let decoder = PropertyListDecoder()
    //
    //            do{
    //                items = try decoder.decode([Item].self, from: data)
    //            } catch {
    //                print("Error in decoding \(error)")
    //            }
    //        }
    //
    //
    //    }
    
}



