//
//  ViewController.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var model: AppDBProjectViewModelType?

    lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Browse"

        table.dataSource = self
        table.delegate = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.ReuseID)

        model = AppDBProjectViewModel(with: .shared)
        model?.bindUpdating {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }

        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }

        model?.getData()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.ReuseID, for: indexPath) as? ProjectTableViewCell else {
            return ProjectTableViewCell()
        }
        guard let model = model else { return ProjectTableViewCell() }
        cell.configure(model: model, for: indexPath.row)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let favoriteAction = UIContextualAction(style: .normal, title: "Add to Cart") { whoAction, inView, actionPerformed in
            let item = self.model?.addToCart(with: indexPath.row)
            actionPerformed(item != nil)
        }

        favoriteAction.image = UIImage(systemName: "cart")
        favoriteAction.backgroundColor = UIColor(named: "AccentColor")
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }

}
