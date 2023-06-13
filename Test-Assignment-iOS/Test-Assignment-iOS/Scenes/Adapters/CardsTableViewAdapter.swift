//
//  CardsTableViewAdapter.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxCocoa
import RxSwift
import UIKit

final class CardsTableViewAdapter<Item: Hashable>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var selectedItem = PublishSubject<Item>()
    
    private let tableView: UITableView
    private let disposeBag = DisposeBag()
    private let cellIdentifier: (Item) -> String
    private let render: (Item, UITableViewCell) -> Void
    private var items: [Item] = []
    
    public init(tableView: UITableView,
                registerCells: (UITableView) -> Void,
                cellIdentifier: @escaping (Item) -> String,
                render: @escaping (Item, UITableViewCell) -> Void) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.render = render
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        registerCells(tableView)
    }
    
    public func update(items: [Item], animated: Bool = false) {
        guard items != self.items else {
            return
        }

        self.items = items
        if animated {
            self.tableView.reloadData()
            
        } else {
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
        }
    }

    public func scrollToRow(at position: Int,
                            at scrollPosition: UITableView.ScrollPosition = .top,
                            animated: Bool = true) {
        self.tableView.scrollToRow(
            at: IndexPath(row: position, section: 0),
            at: scrollPosition,
            animated: animated
        )
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cellIdentifier = self.cellIdentifier(item)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        self.render(item, cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem.onNext(items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

