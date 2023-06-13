//
//  FavoritePhotosTableViewCell.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import UIKit

class FavoritePhotosTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    private lazy var authorImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "tennis")
        image.layer.cornerRadius = 70
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemPink
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    //MARK: - Methods
    private func addSubviews() {
        [authorImageView, nameLabel].forEach { contentView.addSubview($0) }
        authorImageView.addSubview(activityIndicator)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            authorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            authorImageView.widthAnchor.constraint(equalToConstant: 140),
            authorImageView.heightAnchor.constraint(equalToConstant: 140),

            nameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: authorImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor)
        ])
    }
}
