//
//  TableViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/11/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private enum DataSource: String {
    
    case BasicControlsViewController = "Basic Controls"
    case TwoWayBindingViewController = "Two-Way Binding"
    
    static let allValues: [DataSource] = [.BasicControlsViewController, .TwoWayBindingViewController]
    
  }
  
  private let dataSource$ = Observable.just(DataSource.allValues)
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource$.bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) { row, element, cell in
      cell.textLabel?.text = element.rawValue
    }.addDisposableTo(disposeBag)
    
    tableView.rx_modelSelected(DataSource)
      .map { String($0) }
      .subscribeNext { [weak self] in
        self?.performSegueWithIdentifier($0, sender: nil)
    }.addDisposableTo(disposeBag)
  }
  
}
