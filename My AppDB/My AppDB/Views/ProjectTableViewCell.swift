//
//  ProjectTableViewCell.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import UIKit
import SnapKit

class ProjectTableViewCell: UITableViewCell {

    static let ReuseID = "\(ProjectTableViewCell.self)"

    lazy var projectIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    lazy var projectName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Project Name"
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    lazy var projectId: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "id.project"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    var model: AppDBProjectViewModelType?
    var index: Int = -1

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let labelStack = UIStackView(arrangedSubviews: [projectName, projectId])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [projectIcon, labelStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.spacing = 8

        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        projectIcon.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }


    }

    func configure(model: AppDBProjectViewModelType, for index: Int) {
        self.model = model
        self.index = index
        model.bindUpdating {
            self.updateState()
        }
        self.updateState()
    }

    func updateState() {
        guard let project = model?.getProject(with: index) else { return }
        projectName.text = project.name
        projectId.text = project.id

        Task {
            if let projectImage = await model?.getProjectImage(from: project.icon) {
                projectIcon.image = projectImage
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
