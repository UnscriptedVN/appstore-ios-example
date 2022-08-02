//
//  AppDBProjectViewModel.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import UIKit
import Alamofire

protocol ViewModelCapable {
    func bindUpdating(handler: @escaping () -> Void)
    func getData()
}

protocol AppDBProjectViewModelAttributes {
    var count: Int { get }
    func getProject(with index: Int) -> AppDBProject?
    func getProjectImage(from url: URLConvertible) async -> UIImage?
    func addToCart(with index: Int) -> CartItem?
}

typealias AppDBProjectViewModelType = ViewModelCapable & AppDBProjectViewModelAttributes

class AppDBProjectViewModel {
    typealias UpdateHandlerType = () -> Void

    private var projects: [AppDBProject] = [] {
        didSet {
            updateHandler?()
        }
    }

    private var updateHandler: UpdateHandlerType?
    private var provider: AppDBNetwork

    init(with provider: AppDBNetwork) {
        self.provider = provider
    }

}

// MARK: - View Model Capabilities

extension AppDBProjectViewModel: ViewModelCapable {

    func bindUpdating(handler: @escaping () -> Void) {
        updateHandler = handler
    }

    func getData() {
        Task {
            do {
                projects = try await provider.getProjects()
            } catch {
                print("Error: \(error)")
            }

        }
    }


}


// MARK: - App DB View Model Attributes
extension AppDBProjectViewModel: AppDBProjectViewModelAttributes {
    var count: Int {
        return projects.count
    }

    func getProject(with index: Int) -> AppDBProject? {
        guard !projects.isEmpty else { return nil }
        return projects[index]
    }

    func getProjectImage(from url: URLConvertible) async -> UIImage? {
        do {
            let data = try await provider.getImageData(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

    func addToCart(with index: Int) -> CartItem? {
        guard let project = getProject(with: index) else { return nil }
        return CartManager.shared.addToCart(project)
    }
}
