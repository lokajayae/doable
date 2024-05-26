//
//  CategoryListViewController.swift
//  doable
//
//  Created by Evan Lokajaya on 19/05/24.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryListViewController: UIViewController {
    
    
    @IBOutlet weak var categoriesTableView: UITableView!
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(CategoryCell.nib(), forCellReuseIdentifier: CategoryCell.identifier)
        self.loadItems()
        super.viewDidLoad()

    }
    
    
    @IBAction func onClickAddNewCategory(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowCategoryFormModally", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for Segue")
        if segue.identifier == "ShowCategoryFormModally" {
            if let formCategoryController = segue.destination as? CategoryFormViewController {
                formCategoryController.delegate = self
            }
        }
        else if segue.identifier == "ShowCategoryToDoList" {
            if let toDoListViewController = segue.destination as? ToDoListItemViewController, let indexPath = categoriesTableView.indexPathForSelectedRow {
                let selectedCategory = categories[indexPath.row]
                toDoListViewController.selectedCategory = selectedCategory
            }
        }
    }
    
    func loadItems(_ request: NSFetchRequest<Category> = Category.fetchRequest())  {
        do {
            self.categories = try context.fetch(request)
        }
        catch {
            print("Error while fetch data from Core Data \(error)")
        }
        
        self.categoriesTableView.reloadData()
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

// MARK: - Data Source
extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.delegate = self
        cell.categoryName.text = categories[indexPath.row].name
        cell.emojiLogo.text = categories[indexPath.row].emojiLogo ?? "😃"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Perform Segue at Categories Table View")
        performSegue(withIdentifier: "ShowCategoryToDoList", sender: self)
    }
    
    
}

// MARK: - Swipe Cell
extension CategoryListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else {return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(self.categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
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

// MARK: -Form Delegate
extension CategoryListViewController: FormModalControllerDelegate {
    func formModalControllerDidDismiss(_ controller: UIViewController) {
        self.loadItems()
    }
}
