//
//  ExamplesViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/11/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ExamplesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    enum DataSource: String {
        
        case BasicControlsViewController = "Basic Controls"
        case TwoWayBindingViewController = "Two-Way Binding"
        case SectionedTableViewReloadViewController = "Reload Data Source"
        case SectionedTableViewAnimatedViewController = "Animated Data Source"
        
        static let allValues: [DataSource] = [.BasicControlsViewController, .TwoWayBindingViewController, .SectionedTableViewReloadViewController, .SectionedTableViewAnimatedViewController]
        
    }
    
    var collapseDetailViewController = true
    let dataSource = Observable.just(DataSource.allValues)
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
        
        dataSource.bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) { row, element, cell in
            cell.textLabel?.text = element.rawValue
            }.addDisposableTo(disposeBag)
        
        tableView.rx_modelSelected(DataSource)
            //      .distinctUntilChanged()
            .map { String($0) }
            .subscribeNext { [weak self] in
                
                //        if NSProcessInfo.processInfo().environment["TRACE_RESOURCES"] != nil {
                //          print(RxSwift.resourceCount)
                //        }
                
                self?.performSegueWithIdentifier($0, sender: nil)
                self?.collapseDetailViewController = false
            }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
    }
    
}

extension ExamplesViewController: UISplitViewControllerDelegate {
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
    
}
