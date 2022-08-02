//
//  CartViewController.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import UIKit
import SnapKit

class CartViewController: UIViewController {

    var model: CartViewModelType = CartViewModel(with: .shared)

    lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.getData()
        self.table.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Cart"

        table.dataSource = self
        table.delegate = self
        table.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.ReuseID)

        // FIXME: This might not be binding correctly.
        model.bindUpdating {
            self.table.reloadData()
        }

        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }

        model.getData()
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.ReuseID,
            for: indexPath
        ) as? CartTableViewCell else {
            return CartTableViewCell()
        }
        cell.configure(model: model, for: indexPath.row)
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = self.model.getCartItem(at: indexPath.row) else { return nil }

        let action = UIContextualAction(style: .destructive, title: "Remove from Cart") { whoAction, inView, actionPerformed in
            self.model.removeCartItem(item)
            actionPerformed(true)
            self.table.reloadData()
        }
        action.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [action])

    }
}
