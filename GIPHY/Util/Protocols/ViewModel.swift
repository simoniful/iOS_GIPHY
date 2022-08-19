//
//  ViewModel.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
    var disposeBag: DisposeBag { get set }
}
