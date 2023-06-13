//
//  Controller.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

protocol Controller: AnyObject {
    associatedtype ViewModelType: ViewModel
    init(viewModel: ViewModelType)
    func bindOutputs(with viewModel: ViewModelType)
}
