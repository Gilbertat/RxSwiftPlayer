//
//  PresentedTextViewViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/21/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift

class PresentedTextViewViewController: UIViewController, HasTwoWayBindingViewControllerViewModel {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    // HasTwoWayBindingViewControllerViewModel
    var viewModel: TwoWayBindingViewControllerViewModel!
    
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        bindViewModel()
    }
    
    func bindViewModel() {
        (textView.rx.text <-> viewModel.textViewText).addDisposableTo(disposeBag)
    }
    
}
