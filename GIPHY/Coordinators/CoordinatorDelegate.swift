//
//  CoordinatorDelegate.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}
