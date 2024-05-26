//
//  CategoryFormViewController.swift
//  doable
//
//  Created by Evan Lokajaya on 19/05/24.
//

import UIKit
import EmojiPicker
import CoreData

class CategoryFormViewController: UIViewController {
    
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    var delegate: FormModalControllerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emojiButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func openEmojiPicker(_ sender: UIButton) {
        self.openEmojiPickerModule(sender)
    }
    
    @objc private func openEmojiPickerModule(_ sender: UIButton) {
        let viewController = EmojiPickerViewController()
        viewController.sourceView = sender
        viewController.delegate = self
        
        /// # Optional parameters
        viewController.selectedEmojiCategoryTintColor = .systemRed
        viewController.arrowDirection = .up
        viewController.horizontalInset = 16
        viewController.isDismissedAfterChoosing = true
        viewController.customHeight = 300
        viewController.feedbackGeneratorStyle = .soft
        
        present(viewController, animated: true)
    }
    
    
    @IBAction func onClickAddCategory(_ sender: UIButton) {
        let newCategory = Category(context: self.context)
        newCategory.name = nameTextField.text!
        newCategory.emojiLogo = emojiButton.currentTitle!
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


// MARK: - EmojiPicker Delegate
extension CategoryFormViewController: EmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        self.emojiButton.setTitle(emoji, for: .normal)
    }
}

//MARK: - TextFieldDelegate
extension CategoryFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
