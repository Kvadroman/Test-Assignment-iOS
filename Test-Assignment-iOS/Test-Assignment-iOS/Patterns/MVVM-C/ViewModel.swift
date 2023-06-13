//
//  ViewModel.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}
