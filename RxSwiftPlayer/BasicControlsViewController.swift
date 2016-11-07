//
//  BasicControlsViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/5/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BasicControlsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var button: Button!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    
    @IBOutlet var valueChangedControls: [AnyObject]!
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    var skip = 1
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        textField.rx.text.asDriver()
            .drive(textFieldLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        textField.rx.text.asDriver()
            .drive(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3) { self?.view.layoutIfNeeded() }
            }).addDisposableTo(disposeBag)
                    
        textView.rx.text.asDriver()
            .drive(onNext: { [weak self] in
                self?.textViewLabel.rx.text.onNext("Character count: \($0?.characters.count)")
            }).addDisposableTo(disposeBag)
        
        button.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.buttonLabel.text! += "Tapped. "
                self?.view.endEditing(true)
                UIView.animate(withDuration: 0.3) { self?.view.layoutIfNeeded() }
            }).addDisposableTo(disposeBag)
        
        segmentedControl.rx.value.asDriver()
            .skip(skip)
            .drive(onNext: { [weak self] in
                self?.segmentedControlLabel.text = "Selected segment: \($0)"
                UIView.animate(withDuration: 0.3) { self?.view.layoutIfNeeded() }
            }).addDisposableTo(disposeBag)
        
        slider.rx.value.asDriver()
            .drive(onNext: { [weak self] in
                self?.sliderLabel.text = "Slider value: \($0)"
            }).addDisposableTo(disposeBag)
        
        slider.rx.value.asDriver()
            .drive(onNext: { [weak self] in
                self?.progressView.progress = $0
            }).addDisposableTo(disposeBag)
        
        `switch`.rx.value.asDriver()
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        `switch`.rx.value.asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
        stepper.rx.value.asDriver()
            .map { String(Int($0)) }
            .drive(onNext: { [weak self] in
                self?.stepperLabel.text = $0
            }).addDisposableTo(disposeBag)
        
        tapGestureRecognizer.rx.event.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).addDisposableTo(disposeBag)
        
        datePicker.rx.date.asDriver()
            .map { [weak self] in
                self?.dateFormatter.string(from: $0) ?? ""
            }
            .drive(onNext: { [weak self] in
                self?.datePickerLabel.text = "Selected date: \($0)"
            }).addDisposableTo(disposeBag)
        
        resetBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.textField.rx.text.onNext("")
                
                self.textView.rx.text.onNext("Text view")
                
                self.buttonLabel.rx.text.onNext("")
                
                self.skip = 0
                self.segmentedControl.rx.value.onNext(-1)
                self.segmentedControlLabel.text = ""
                
                self.slider.rx.value.onNext(0.5)
                
                self.`switch`.rx.value.onNext(false)
                
                self.stepper.rx.value.onNext(0.0)
                
                self.datePicker.setDate(Date(), animated: true)
                                
                self.valueChangedControls.forEach { $0.sendActions(for: .valueChanged) }
                self.view.endEditing(true)
                UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
            }).addDisposableTo(disposeBag)
    }
    
}
