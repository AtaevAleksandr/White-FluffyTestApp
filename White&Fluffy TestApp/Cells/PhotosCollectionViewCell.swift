//
//  PhotosCollectionViewCell.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
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
        image.tintColor = .systemGray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        //        image.layer.borderColor = UIColor.systemPink.cgColor
        //        image.layer.borderWidth = 1
        image.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.startAnimating()
        return image
    }()

    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemPink
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    //MARK: - Methods
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

    func set() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.imageView.image = UIImage(systemName: "photo")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }

}
