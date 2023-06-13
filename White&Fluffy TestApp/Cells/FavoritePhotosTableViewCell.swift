//
//  FavoritePhotosTableViewCell.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import UIKit
import SDWebImage

class FavoritePhotosTableViewCell: UITableViewCell {

    var favoritePhotos: DetailedUnsplashPhoto! {
        didSet {
            let favoritePhotoUrl = favoritePhotos.urls["small"]
            guard let photoUrl = favoritePhotoUrl, let url = URL(string: photoUrl) else { return }
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            self.nameLabel.text = favoritePhotos.user.name
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.authorImageView.sd_setImage(with: url) { [weak self] (image, error, _, _) in
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    if let error = error {
                        print("Image loading error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    private lazy var authorImageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .systemGray2
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
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
            authorImageView.widthAnchor.constraint(equalToConstant: 100),
            authorImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: authorImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor)
        ])
    }
}
