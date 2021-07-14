//
//  AddEventViewController.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import UIKit

class AddEventViewController: UIViewController {
    
    private var viewModel: AddEventViewModel?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddEventViewModel()
        self.title = self.viewModel?.title
        
        setupViews()
        bind()
    }
    
    private func bind() {
        self.viewModel?.didFinish = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.viewModel?.showError = { [weak self] message in
            self?.showSystemAlert(title: "Atention!", message: message)
        }
    }
    
    private func setupViews() {
        self.saveButton.layer.cornerRadius = 5
        self.saveButton.clipsToBounds = true
        self.saveButton.backgroundColor = .specialBlue
        
        // add date picker to dateTextField action
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        self.dateTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePickerChange), for: .valueChanged)
        
        self.nameTextField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
    }

    @IBAction func tappedSaveButton(_ sender: Any) {
        self.viewModel?.save()
    }
    
    @objc func handleDatePickerChange(sender: UIDatePicker) {
        self.dateTextField.text = sender.date.toString()
        self.viewModel?.updateData(name: nil, date: sender.date)
    }
    
    @objc func handleNameChange(sender: UITextField) {
        self.viewModel?.updateData(name: sender.text, date: nil)
    }
}
