//
//  EventItem.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import UIKit

class EventItem: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var countdownView: UIVisualEffectView!
    @IBOutlet weak var countdownViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var viewModel: EventItemViewModel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    deinit {
        self.viewModel?.stopTimer()
    }
    
    public func initialize(with viewModel: EventItemViewModel) {
        self.viewModel = viewModel
        self.titleLabel.text = self.viewModel?.name
        self.dueDateLabel.text = self.viewModel?.date.toString()
        self.countdownLabel.text = self.viewModel?.remainingTime
        
        self.viewModel?.didUpdateTimer = { [weak self] in
            self?.countdownLabel.text = self?.viewModel?.remainingTime
            if self?.viewModel?.remainingTime == "00:00:00" {
                self?.hideTimer()
            }
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EventItem", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        mainView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        mainView.backgroundColor = .specialBlue
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        countdownView.layer.cornerRadius = 10
        countdownView.clipsToBounds = true
    }
    
    private func hideTimer() {
        self.countdownLabel.isHidden = true
        self.checkmarkImageView.isHidden = false
        self.countdownView.effect = UIBlurEffect(style: .systemThickMaterialLight)
        self.countdownViewWidthConstraint?.isActive = false
        self.countdownView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

}
