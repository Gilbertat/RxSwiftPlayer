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

extension String: IdentifiableType {
  
  public typealias Identity = String
  
  public var identity: Identity { return self }
  
}

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
  
  let data = Variable<[AnimatedSectionModel]>([
    AnimatedSectionModel(title: "Section 1", dataSourceItems: ["Sample Data 1-1", "Sample Data 1-2"])
    ])
  
  let disposeBag = DisposeBag()
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource.configureCell = { _, tableView, indexPath, dataSourceItem in
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
      cell.textLabel!.text = dataSourceItem
      return cell
    }
    
    data.asDriver()
      .drive(tableView.rx_itemsWithDataSource(dataSource))
      .addDisposableTo(disposeBag)
    
    dataSource.titleForHeaderInSection = {
      $0.sectionAtIndex($1).title
    }
    
    addBarButtonItem.rx_tap.asDriver()
      .driveNext { [weak self] _ in
        guard let strongSelf = self else { return }
        let index = strongSelf.data.value.count + 1
        strongSelf.data.value += [AnimatedSectionModel(title: "Section \(index)", dataSourceItems: ["Sample Data \(index)-1", "Sample Data \(index)-2"])]
      }.addDisposableTo(disposeBag)
  }
  
}
