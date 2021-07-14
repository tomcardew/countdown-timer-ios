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
            stackView.addArrangedSubview(view)
        }
    }

}
