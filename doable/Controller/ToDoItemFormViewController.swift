//
//  ToDoItemFormViewController.swift
//  doable
//
//  Created by Evan Lokajaya on 23/05/24.
//

import UIKit

class ToDoItemFormViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: FormModalControllerDelegate?
    var category: Category?
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        dueDatePicker.minimumDate = Date()
    }
    
    
    @IBAction func onChangeDueDatePicker(_ sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    
    @IBAction func onClickAddToDoItem(_ sender: UIButton) {
        let newItem = Item(context: self.context)
        newItem.title = titleTextField.text!
        newItem.isDone = false
        newItem.parentCategory = self.category!
        newItem.dueDate = selectedDate
        self.saveData()
        delegate?.formModalControllerDidDismiss(self)
        self.dismiss(animated: true)
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

//MARK: - TextFieldDelegate
extension ToDoItemFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
