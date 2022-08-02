//
//  CartManager.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import Foundation
import CoreData

class CartManager {
    static let shared = CartManager()

    func addToCart(_ project: AppDBProject) -> CartItem? {
        var item: CartItem? = nil

        PersistenceController.shared.doInContext { context in
            let newItem = CartItem(context: context)
            newItem.icon = project.icon
            newItem.name = project.name
            newItem.id = project.id
            item = newItem
        }

        print(item)

        return item
    }

    func removeFromCart(_ item: CartItem) {
        PersistenceController.shared.doInContext { context in
            context.delete(item)
        }
    }

    func getCartItems() -> [CartItem] {
        let fetchRequest = CartItem.fetchRequest()
        do {
            return try PersistenceController.shared
                .persistentContainer
                .viewContext
                .fetch(fetchRequest)
        } catch {
            return []
        }
    }

}
