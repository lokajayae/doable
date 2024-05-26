//
//  ToDoListItemViewController.swift
//  doable
//
//  Created by Evan Lokajaya on 19/05/24.
//

import UIKit
import CoreData
import SwipeCellKit

class ToDoListItemViewController: UIViewController {
    
    @IBOutlet weak var toDoItemTableView: UITableView!
    
    var items = [Item]()
    var navigationTitle:String?

    var selectedCategory: Category? {
        didSet {
            self.navigationTitle = selectedCategory?.name
            self.loadItems()
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        print("Start View Did Load")
        self.toDoItemTableView.delegate = self
        self.toDoItemTableView.dataSource = self
        self.toDoItemTableView.register(ToDoItemCell.nib(), forCellReuseIdentifier: ToDoItemCell.identifier)
        
        if let navBarTitle = self.navigationTitle {
            self.title = navBarTitle
        }
        else {
            self.title = "To Do List"
        }
        dateFormatter.dateFormat = "d MMMM yyyy, 'at' h:mm a"
        self.loadItems()
        self.toDoItemTableView.reloadData()
        super.viewDidLoad()

    }
    
    @IBAction func onCLickAddNewToDoItem(_ sender: Any) {
        performSegue(withIdentifier: "ShowToDoItemFormModally", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue")
        if segue.identifier == "ShowToDoItemFormModally" {
            if let toDoItemForm = segue.destination as? ToDoItemFormViewController {
                toDoItemForm.delegate = self
                toDoItemForm.category = self.selectedCategory
            }
        }
    }
    
    func loadItems()  {
        print("load items called")
        do {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
            request.predicate = categoryPredicate
            self.items = try context.fetch(request)
        }
        catch {
            print("Error while fetch data from Core Data \(error)")
        }
    }
    
    func saveData() {
        do {
            try context.save()
        }
        catch {
            print("Error saving Core Data \(error)")
        }
    }
    

}

// MARK: -Table View Data Souce
extension ToDoListItemViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemCell.identifier, for: indexPath)  as! ToDoItemCell
        
        cell.delegate = self
        cell.title.text = items[indexPath.row].title
        
        if let dateValue = items[indexPath.row].dueDate {
            cell.date.text = dateFormatter.string(from: dateValue)
        }
        else {
            cell.date.text = "-"
        }
        
        if items[indexPath.row].isDone {
            cell.checkmarkImage.image = UIImage(systemName: "checkmark.circle.fill")
        }
        else {
            cell.checkmarkImage.image = UIImage(systemName: "circle")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
}

extension ToDoListItemViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else {return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            self.saveData()
            
        }
        deleteAction.image = UIImage(named: "trash-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

extension ToDoListItemViewController: FormModalControllerDelegate {
    func formModalControllerDidDismiss(_ controller: UIViewController) {
        self.loadItems()
        self.toDoItemTableView.reloadData()
    }
}
    
