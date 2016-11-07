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
    let variableToProperty = variable.asObservable()
        .bindTo(property)
    
    let propertyToVariable = property
        .subscribe(onNext: {
            variable.value = $0
            }, onCompleted: {
                variableToProperty.dispose()
        })
    
    return StableCompositeDisposable.create(variableToProperty, propertyToVariable)
}

class TwoWayBindingViewControllerViewModel {
    
    var textFieldText = Variable("Hello")
    var textViewText = Variable("Lorem ipsum dolor...")
    
}

protocol HasTwoWayBindingViewControllerViewModel: class {
    
    var viewModel: TwoWayBindingViewControllerViewModel! { get set }
    
}

class TwoWayBindingViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var resetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    
    let viewModel = TwoWayBindingViewControllerViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindViewModel()
        
        tapGestureRecognizer.rx_event.asDriver()
            .driveNext { [weak self] _ in
                self?.view.endEditing(true)
            }.addDisposableTo(disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let controller = (segue.destinationViewController as? UINavigationController)?.topViewController as? HasTwoWayBindingViewControllerViewModel else { return }
        controller.viewModel = viewModel
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToTwoWayBindingViewController(segue: UIStoryboardSegue) { }
    
    // MARK: - Helpers
    
    func configure() {
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        button.layer.cornerRadius = 5.0
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).CGColor
    }
    
    func bindViewModel() {
        leftTextField.rx_text <-> viewModel.textFieldText
        
        rightTextField.rx_text <-> viewModel.textFieldText
        
        button.rx_tap.asDriver()
            .driveNext { [weak self] in
                self?.viewModel.textFieldText.value = String(NSDate())
            }.addDisposableTo(disposeBag)
        
        resetBarButtonItem.rx_tap.asDriver()
            .driveNext { [weak self] _ in
                self?.viewModel.textFieldText.value = "Hello"
                self?.viewModel.textViewText.value = "Lorem ipsum dolor..."
            }.addDisposableTo(disposeBag)
    }
    
}
