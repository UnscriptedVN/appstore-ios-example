//
//  CartViewModel.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import UIKit
import Alamofire

protocol CartViewModelAttributes {
    var count: Int { get }
    func getCartItem(at index: Int) -> CartItem?
    func getCartImage(from url: URLConvertible) async -> UIImage?
    func removeCartItem(_ item: CartItem)
}

typealias CartViewModelType = ViewModelCapable & CartViewModelAttributes

class CartViewModel {
    typealias UpdateHandlerType = () -> Void

    private var cart = [CartItem]() {
        didSet {
            updateHandler?()
        }
    }

    private var updateHandler: UpdateHandlerType?
    private var provider: CartManager

    init(with provider: CartManager) {
        self.provider = provider
    }
}

// MARK: - View Model Capabilites
extension CartViewModel: ViewModelCapable {
    func bindUpdating(handler: @escaping () -> Void) {
        self.updateHandler = handler
    }

    func getData() {
        cart = provider.getCartItems()
    }
}

// MARK: - Cart View Model Attributes
extension CartViewModel: CartViewModelAttributes {
    var count: Int {
        return cart.count
    }

    func getCartItem(at index: Int) -> CartItem? {
        guard !cart.isEmpty else { return nil }
        guard index < cart.count else { return nil }
        return cart[index]
    }

    func getCartImage(from url: URLConvertible) async -> UIImage? {
        do {
            let data = try await AppDBNetwork.shared.getImageData(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }

    func removeCartItem(_ item: CartItem) {
        provider.removeFromCart(item)
        cart.removeAll { cartItem in cartItem.id == item.id }
    }
}
