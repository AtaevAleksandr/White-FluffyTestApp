//
//  PhotosCollectionViewCell.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import UIKit
import SDWebImage

class PhotosCollectionViewCell: UICollectionViewCell {

    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.imageView.sd_setImage(with: url) { [weak self] (image, error, _, _) in
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    if let error = error {
                        print("Image loading error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Clousers
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemPink
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    //MARK: - Methods
    private func addSubviews() {
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
