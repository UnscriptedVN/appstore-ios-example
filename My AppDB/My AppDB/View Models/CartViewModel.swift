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

    private var shoppingCart = [CartItem]() {
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
        updateHandler = handler
    }

    func getData() {
        shoppingCart = provider.getCartItems()
    }
}

// MARK: - Cart View Model Attributes
extension CartViewModel: CartViewModelAttributes {
    var count: Int {
        return shoppingCart.count
    }

    func getCartItem(at index: Int) -> CartItem? {
        guard !shoppingCart.isEmpty else { return nil }
        guard index < shoppingCart.count else { return nil }
        return shoppingCart[index]
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
        shoppingCart.removeAll { cartItem in cartItem.id == item.id }
    }
}
