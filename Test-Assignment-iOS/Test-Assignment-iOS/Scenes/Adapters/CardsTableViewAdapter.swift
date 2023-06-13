//
//  CardsTableViewAdapter.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import CombineCocoa
import UIKit

final class CardsTableViewAdapter<Item: Hashable>: NSObject, UITableViewDelegate {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Public properties
    
    public var selectItem: AnyPublisher<AnyHashable, Never> {
        selectedItem.eraseToAnyPublisher()
    }
    
    public var defaultRowAnimation: UITableView.RowAnimation = .automatic {
        didSet {
            self.dataSource.defaultRowAnimation = defaultRowAnimation
        }
    }
    
    // MARK: - Private properties
    
    private let tableView: UITableView
    private var cancellables: Set<AnyCancellable> = []
    private var selectedItem = PassthroughSubject<AnyHashable, Never>()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        let dataSource = UITableViewDiffableDataSource<Section, Item>(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
                let cellIdentifier = self?.cellIdentifier(item) ?? "Cell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                         for: indexPath)
                self?.render(item, cell)
                return cell
            }
        )
        tableView.delegate = self
        dataSource.defaultRowAnimation = self.defaultRowAnimation
        // ---
        // Set initial dataSource state to empty
        // This need to fix strange crash with incorrect section count insertion/deletion
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems([], toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: false)
        // ---
        return dataSource
    }()
    
    private let cellIdentifier: (Item) -> String
    
    private let render: (Item, UITableViewCell) -> Void
    
    private var items: [Item] = []
    
    // MARK: - Initializations and Deallocations
    
    public init(tableView: UITableView,
                defaultRowAnimation: UITableView.RowAnimation = .none,
                registerCells: (UITableView) -> Void,
                cellIdentifier: @escaping (Item) -> String,
                render: @escaping (Item, UITableViewCell) -> Void) {
        self.defaultRowAnimation = defaultRowAnimation
        self.tableView = tableView
        registerCells(tableView)
        self.cellIdentifier = cellIdentifier
        self.render = render
    }
    
    // MARK: - Public methods
    
    public func update(items: [Item], animated: Bool = false) {
        guard items != self.items else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        let reload = {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        if animated {
            reload()
        } else {
            // Allow diffs without animation.
            UIView.animate(withDuration: 0) {
                reload()
            }
        }
        self.items = items
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem.send(items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

