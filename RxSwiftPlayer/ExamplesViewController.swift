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
        
        dataSource.bindTo(tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
            cell.textLabel?.text = element.rawValue
        }.addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(DataSource.self)
//            .distinctUntilChanged()
            .map { "\($0)" }
            .subscribe(onNext: { [weak self] in
                
                if ProcessInfo.processInfo.environment["TRACE_RESOURCES"] != nil {
                    print(RxSwift.Resources.total)
                }
                
                self?.performSegue(withIdentifier: $0, sender: nil)
                self?.collapseDetailViewController = false
            }).addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
    
}

extension ExamplesViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
    
}
