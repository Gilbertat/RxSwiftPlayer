//
//  SectionedTableViewReloadViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/13/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

enum ReloadDataSource: String {
    
    case SampleData1 = "Sample Data 1"
    case SampleData2 = "Sample Data 2"
    
    static let allValues: [ReloadDataSource] = [.SampleData1, .SampleData2]
    
}

extension ReloadDataSource: IdentifiableType {
    
    var identity: String { return rawValue }
    
}

class SectionedTableViewReloadViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ReloadDataSource>>()
    
    let data = Variable([
        SectionModel(model: "Section 1", items: ReloadDataSource.allValues)
        ])
    
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = { _, tableView, indexPath, dataSourceItem in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel!.text = dataSourceItem.rawValue
            return cell
        }
        
        data.asDriver()
        .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.titleForHeaderInSection = {
            $0[$1].model
        }
        
        addBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.data.value += [SectionModel(model: "Section \(strongSelf.data.value.count + 1)", items: ReloadDataSource.allValues)]
            }).addDisposableTo(disposeBag)
    }
    
}
