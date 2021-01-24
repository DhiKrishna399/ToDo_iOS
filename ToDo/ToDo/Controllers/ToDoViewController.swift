//
//  ViewController.swift
//  ToDo
//
//  Created by Dhiva Krishna on 1/4/21.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var items: [Item] = []
    
    //    //File Path for storing data into a PList
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Access to CoreData persistentContainer
    //We must call context in order, to create, save, and fetch data from the container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        loadItems()
        
        
        //Search for the file based off the key
        //        if let storedItems = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            items = storedItems
        //        }
    }
    
 
    
// MARK: - Table View Setup
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
        
        //         Used to delete items from the table view and Container
        //        context.delete(items[indexPath.row] as NSManagedObject)
        //        items.remove(at: indexPath.row)
        //
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//  MARK: - Data Manipulation
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
    
// MARK: - Save&Load Core Data
    
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
    
    
    //Using a defauly parameter to avoid declaring a FethRequest everytime
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        do {
            //set items array to be equal to values from the container
            items = try context.fetch(request)
        } catch {
            print("Error with fetching from container \(error)")
        }
        
        tableView.reloadData()
        
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
    }
    
   
     
}

// MARK: - SearchBarDelegate
extension ToDoViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Retrieve the list from Container
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //print(searchBar.text!)
        
        //A mix of SQL/C querying
        //[cd] makes query insensitive to cases and diacretics
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
       

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Using this puts it on the main thread and stops the cursor from blinking in the search bar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }

}





