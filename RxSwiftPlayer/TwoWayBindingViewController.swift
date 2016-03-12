//
//  TwoWayBindingViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/8/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

infix operator <-> { precedence 130 associativity left }

func <-><T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
  let variableToProperty = variable.asObservable().bindTo(property)
  
  let propertyToVariable = property.subscribe(
    onNext: { variable.value = $0 },
    onCompleted: { variableToProperty.dispose() }
  )
  
  return StableCompositeDisposable.create(variableToProperty, propertyToVariable)
}

func <-><T: Comparable>(left: Variable<T>, right: Variable<T>) -> Disposable {
  let leftDrivesRight = left.asDriver().driveNext {
    guard right.value != $0 else { return }
    right.value = $0
  }
  
  let leftObservesRight = right.asObservable().bindNext {
    guard left.value != $0 else { return }
    left.value = $0
  }
  
  return StableCompositeDisposable.create(leftDrivesRight, leftObservesRight)
}

class TwoWayBindingViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var resetButton: UIBarButtonItem!
  @IBOutlet weak var leftTextField: UITextField!
  @IBOutlet weak var rightTextField: UITextField!
  @IBOutlet weak var button: UIButton!
  
  // MARK: - Properties
  
  let string$ = Variable<String>("Hello")
  let disposeBag = DisposeBag()
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
    navigationItem.leftItemsSupplementBackButton = true
    button.layer.cornerRadius = 5.0
    
    leftTextField.rx_text <-> string$
    rightTextField.rx_text <-> string$
    
    let string2$ = Variable<String>("")
    let string3$ = Variable<String>("")
    
    string$ <-> string2$
    string$ <-> string3$
    
    string2$.asObservable()
      .subscribeNext { print("string2$", $0) }
      .addDisposableTo(disposeBag)
    
    string3$.asObservable()
      .subscribeNext { print("string3$", $0) }
      .addDisposableTo(disposeBag)
    
    button.rx_tap.asDriver()
    .driveNext { [weak self] in
      self?.string$.value = String(NSDate())
    }.addDisposableTo(disposeBag)
    
    resetButton.rx_tap.asDriver()
      .driveNext { [weak self] _ in
        self?.string$.value = "Hello"
      }.addDisposableTo(disposeBag)
  }
    
}
