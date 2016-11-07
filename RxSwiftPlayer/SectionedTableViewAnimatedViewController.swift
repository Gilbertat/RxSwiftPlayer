//
//  SectionedTableViewAnimatedViewController.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/13/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

struct AnimatedSectionModel {
    
    let title: String
    var dataSourceItems: [String]
    
}

extension AnimatedSectionModel: AnimatableSectionModelType {
    
    typealias Item = String
    typealias Identity = String
    
    var identity: Identity { return title }
    var items: [Item] { return dataSourceItems }
    
    init(original: AnimatedSectionModel, items: [String]) {
        self = original
        dataSourceItems = items
    }
    
}

class SectionedTableViewAnimatedViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatedSectionModel>()
    
    let data = Variable([
        AnimatedSectionModel(title: "Section 1", dataSourceItems: ["Sample Data 1-1", "Sample Data 1-2"])
        ])
    
    let disposeBag = DisposeBag()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel!.text = item
            return cell
        }
        
        data.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.titleForHeaderInSection = {
            $0[$1].title
        }
        
        addBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                let index = strongSelf.data.value.count + 1
                strongSelf.data.value += [AnimatedSectionModel(title: "Section \(index)", dataSourceItems: ["Sample Data \(index)-1", "Sample Data \(index)-2"])]
            }).addDisposableTo(disposeBag)
    }
    
}
