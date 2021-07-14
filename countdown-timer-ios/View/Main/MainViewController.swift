//
//  MainViewController.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewDidLoad()
    }
    
    private func setupViews() {
        self.title = viewModel.title
        
        let addBtn = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(addEvent))
        addBtn.tintColor = .specialBlue
        navigationItem.rightBarButtonItem = addBtn
    }
    
    private func bind() {
        viewModel.eventsDidChange = { [weak self] in
            self?.updateStackView(with: (self?.viewModel.events)!)
        }
    }
    
    @objc func addEvent() {
        let vc = AddEventViewController.instantiate(fromStoryboard: .addEvent)
        vc.modalPresentationStyle = .currentContext
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateStackView(with events: [NSManagedObject]) {
        stackView.removeAll()
        for event in events.reversed() {
            let view = EventItem()
            let vm = EventItemViewModel(name: event.value(forKey: "name") as! String, date: event.value(forKey: "date") as! Date, id: event.objectID)
            view.initialize(with: vm)
            let gesture = SpecialTapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            gesture.eventItemViewModel = vm
            view.addGestureRecognizer(gesture)
            stackView.addArrangedSubview(view)
        }
    }
    
    @objc func handleTap(sender: SpecialTapGestureRecognizer) {
        self.showSystemAlert(title: sender.eventItemViewModel?.name ?? "", message: "What actions you want to take with this event?", actions: [UIAlertAction(title: "Remove", style: .destructive, handler: {_ in
            self.handleDeleteEvent(from: sender.eventItemViewModel!)
        }), UIAlertAction(title: "Close", style: .default, handler: nil)])
    }
    
    private func handleDeleteEvent(from vm: EventItemViewModel) {
        self.showSystemAlert(title: "Delete event", message: "Are you sure? There's no way back.", actions: [UIAlertAction(title: "Yes, I am", style: .destructive, handler: {_ in
            self.viewModel.deleteEvent(id: vm.objectId)
            vm.removeItem()
        }), UIAlertAction(title: "Cancel", style: .default, handler: nil)])
    }

}

class SpecialTapGestureRecognizer: UITapGestureRecognizer {
    
    var eventItemViewModel: EventItemViewModel?
    
}
