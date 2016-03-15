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
  
  override func didMoveToParentViewController(parent: UIViewController?) {
    guard let controller = parent?.parentViewController as? TwoWayBindingViewController else { return }
    
    expandBarButtonItem.rx_tap.asDriver()
      .driveNext { [weak self] _ in
        controller.performSegueWithIdentifier("PresentedTextViewViewController", sender: self?.expandBarButtonItem)
    }.addDisposableTo(disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
  }
  
  func bindViewModel() {
    textView.rx_text <-> viewModel.textViewText$
  }
  
}
