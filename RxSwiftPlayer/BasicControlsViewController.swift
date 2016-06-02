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
  
  lazy var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
  }()
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    navigationItem.leftItemsSupplementBackButton = true
    
    textField.rx_text.asDriver()
      .drive(textFieldLabel.rx_text)
      .addDisposableTo(disposeBag)
    
    textField.rx_text.asDriver()
      .driveNext { [weak self] _ in
        UIView.animateWithDuration(0.3) { self?.view.layoutIfNeeded() }
      }.addDisposableTo(disposeBag)
    
    textView.rx_text.asDriver()
      .driveNext { [weak self] in
        self?.textViewLabel.rx_text.onNext("Character count: \($0.characters.count)")
      }.addDisposableTo(disposeBag)
    
    button.rx_tap.asDriver()
      .driveNext { [weak self] _ in
        self?.buttonLabel.text! += "Tapped. "
        self?.view.endEditing(true)
        UIView.animateWithDuration(0.3) { self?.view.layoutIfNeeded() }
      }.addDisposableTo(disposeBag)
    
    segmentedControl.rx_value.asDriver()
      .skip(skip)
      .driveNext { [weak self] in
        self?.segmentedControlLabel.text = "Selected segment: \($0)"
        UIView.animateWithDuration(0.3) { self?.view.layoutIfNeeded() }
      }.addDisposableTo(disposeBag)
    
    slider.rx_value.asDriver()
      .driveNext { [weak self] in
        self?.sliderLabel.text = "Slider value: \($0)"
      }.addDisposableTo(disposeBag)
    
    slider.rx_value.asDriver()
      .driveNext { [weak self] in
        self?.progressView.progress = $0
      }.addDisposableTo(disposeBag)
    
    `switch`.rx_value.asDriver()
      .map { !$0 }
      .drive(activityIndicator.rx_hidden)
      .addDisposableTo(disposeBag)
    
    `switch`.rx_value.asDriver()
      .drive(activityIndicator.rx_animating)
      .addDisposableTo(disposeBag)
    
    stepper.rx_value.asDriver()
      .map { String(Int($0)) }
      .driveNext { [weak self] in
        self?.stepperLabel.text = $0
      }.addDisposableTo(disposeBag)
    
    tapGestureRecognizer.rx_event.asDriver()
      .driveNext { [weak self] _ in
        self?.view.endEditing(true)
      }.addDisposableTo(disposeBag)
    
    datePicker.rx_date.asDriver()
      .map { [weak self] in
        self?.dateFormatter.stringFromDate($0) ?? ""
      }
      .driveNext { [weak self] in
        self?.datePickerLabel.text = "Selected date: \($0)"
      }.addDisposableTo(disposeBag)
    
    resetBarButtonItem.rx_tap.asDriver()
      .driveNext { [weak self] _ in
        guard let `self` = self else { return }
        self.textField.rx_text.onNext("")
        
        self.textView.rx_text.onNext("Text view")
        
        self.buttonLabel.rx_text.onNext("")
        
        self.skip = 0
        self.segmentedControl.rx_value.onNext(-1)
        self.segmentedControlLabel.text = ""
        
        self.slider.rx_value.onNext(0.5)
        
        self.`switch`.rx_value.onNext(false)
        
        self.stepper.rx_value.onNext(0.0)
        
        self.datePicker.setDate(NSDate(), animated: true)
        
        self.valueChangedControls.forEach { $0.sendActionsForControlEvents(.ValueChanged) }
        self.view.endEditing(true)
        UIView.animateWithDuration(0.3) { self.view.layoutIfNeeded() }
      }.addDisposableTo(disposeBag)
  }
    
}
