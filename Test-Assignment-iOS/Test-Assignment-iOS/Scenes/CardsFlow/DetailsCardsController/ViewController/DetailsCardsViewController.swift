//
//  DetailsCardsViewController.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class DetailsCardsViewController<T: DetailsCardsViewModeling>: UIViewController, Controller {
    typealias ViewModelType = T
    
    let disposeBag = DisposeBag()
    var cardMask: DetailsCardMaskProtocol?
    
    let viewModel: ViewModelType
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var bankTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Bank"
        view.font = .systemFont(ofSize: 25)
        view.textColor = .white
        return view
    }()
    
    private lazy var cardNumberTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 25)
        return view
    }()
    
    private lazy var cardTypeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        bindOutputs(with: viewModel)
    }
    
    func bindOutputs(with viewModel: T) {
        viewModel.output.cardModel
            .drive(onNext: { [weak self] card in
                self?.setupUI(with: card)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI(with card: Card) {
        let neededColor = UIColor(hexString: card.cardType == .visa ? "#faaa13" : "#222222")
        cardView.backgroundColor = neededColor
        cardNumberTitle.text = cardMask?.mask(detailsCardNumber: card.cardNumber)
        cardTypeImage.image = UIImage(named: card.cardType.rawValue)?.getScaledImage(with: 60)
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(cardView)
        cardView.addSubviews([bankTitle, cardNumberTitle, cardTypeImage])

        cardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }

        bankTitle.snp.makeConstraints { make in
            make.leading.equalTo(cardView.snp.leading).offset(16)
            make.centerY.equalTo(cardView.snp.centerY).offset(-36)
        }

        cardNumberTitle.snp.makeConstraints { make in
            make.leading.equalTo(cardView.snp.leading).offset(16)
            make.centerY.equalTo(cardView.snp.centerY).offset(36)
        }

        cardTypeImage.snp.makeConstraints { make in
            make.trailing.equalTo(cardView.snp.trailing).offset(-16)
            make.centerY.equalTo(cardView.snp.centerY).offset(36)
        }
    }
    
    deinit {
        print(self, "Deinited")
    }
}
