//
//  CardsViewController.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import CombineCocoa
import UIKit

final class CardsViewController<T: CardsViewModeling>: UIViewController, Controller {
    typealias ViewModelType = T
    typealias Adapter = CardsTableViewAdapter
    
    var cancellables: Set<AnyCancellable> = []
    var cardMask: CardMaskProtocol?
    
    // MARK: - Replies Adapter
    private lazy var cardsAdapter: Adapter<Card> = {
        return Adapter(tableView: cardsTableView) { [weak self] tableView in
            self?.registerCells(tableView)
        } cellIdentifier: { [weak self] _ in
            self?.getCommentCellIdentifier() ?? "Cell"
        } render: { [weak self] item, cell in
            self?.renderCell(item, cell)
        }
    }()
    
    lazy var cardsTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let viewModel: ViewModelType
    
    required init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupNavButton()
        bindInputs(with: viewModel)
        bindOutputs(with: viewModel)
    }
    
    private func bindInputs(with viewModel: T) {
        cardsAdapter.selectItem
            .receive(on: DispatchQueue.main)
            .sink { card in
                guard let card = card as? Card else { return }
                viewModel.input.didSelectItem.send(card)
            }
            .store(in: &cancellables)
    }
    
    func bindOutputs(with viewModel: T) {
        viewModel.output.cardsModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cards in
                self?.cardsAdapter.update(items: cards, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func setupConstraints() {
        view.addSubview(cardsTableView)
        NSLayoutConstraint.activate([
            cardsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cardsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cardsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupNavButton() {
        let imageButton = UIImage(systemName: "plus")
        navigationItem.title = "Картки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageButton,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonTapped))
    }
    
    @objc private func rightBarButtonTapped() {
        viewModel.input.didAddCard.send()
    }
}

// MARK: - Cards Adapter
extension CardsViewController {
    private func registerCells(_ tableView: UITableView) {
        tableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: getCommentCellIdentifier())
    }
    
    private func getCommentCellIdentifier() -> String {
        return CardTableViewCell.identifier
    }
    
    private func renderCell(_ item: Card, _ cell: UITableViewCell) {
        guard let cell = cell as? CardTableViewCell else { return }
        cell.configure(with: item, and: cardMask)
    }
}
