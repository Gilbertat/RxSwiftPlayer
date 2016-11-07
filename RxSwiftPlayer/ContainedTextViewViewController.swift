//
//  ContainedTextViewViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/21/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift

class ContainedTextViewViewController: UIViewController, HasTwoWayBindingViewControllerViewModel {
    
    // MARK: - Outlets
    
    @IBOutlet weak var expandBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    
    // HasTwoWayBindingViewControllerViewModel
    var viewModel: TwoWayBindingViewControllerViewModel!
    
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func didMove(toParentViewController parent: UIViewController?) {
        guard let controller = parent?.parent as? TwoWayBindingViewController else { return }
        
        expandBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                controller.performSegue(withIdentifier: "PresentedTextViewViewController", sender: self?.expandBarButtonItem)
            }).addDisposableTo(disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        textView.rx.text <-> viewModel.textViewText
    }
    
}
