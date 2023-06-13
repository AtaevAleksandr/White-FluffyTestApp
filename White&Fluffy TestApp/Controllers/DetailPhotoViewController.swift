//
//  DetailPhotoViewController.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import UIKit
import SDWebImage

protocol DetailPhotoDelegateProtocol: AnyObject {
    func didChangeFavouritesList()
}

class DetailPhotoViewController: UIViewController {
    weak var delegate: DetailPhotoDelegateProtocol?

    var networkDataFetcher: NetworkDataFetcher?
    var id: String? {
        didSet {
            getPhoto()
        }
    }
    var detailedImage: DetailedUnsplashPhoto? {
        didSet {
            updateUI()
        }
    }

    private var isFavourite: Bool = false

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createBarsItems()
        navigationController?.navigationBar.layoutIfNeeded()
    }

    //MARK: - Clousers
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var locationImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "location.fill")
        image.tintColor = .systemGray2
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addToFavoriteButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "Add to favorites ❤️"
        button.configuration?.cornerStyle = .large
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = .systemBlue
        button.addTarget(self, action: #selector(likeOrDislike), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.image = UIImage(systemName: "heart.fill")
        button.configuration?.baseForegroundColor = .systemPink
        button.configuration?.baseBackgroundColor = .clear
        button.addTarget(self, action: #selector(likeOrDislike), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let barButton = UIBarButtonItem(customView: button)
        return button
    }()

    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemPink
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    //MARK: - Methods
    private func addSubviews() {
        [imageView, nameLabel, createdAtLabel, locationLabel, locationImageView, downloadsLabel, addToFavoriteButton].forEach { view.addSubview($0) }
        imageView.addSubview(activityIndicator)
    }
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.4),

            locationImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            locationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),

            locationLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 6),

            createdAtLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor),
            createdAtLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            nameLabel.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: locationImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: createdAtLabel.trailingAnchor),

            downloadsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            downloadsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            addToFavoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToFavoriteButton.heightAnchor.constraint(equalToConstant: 50),
            addToFavoriteButton.widthAnchor.constraint(equalToConstant: 250),
            addToFavoriteButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 100),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    private func createBarsItems() {
        navigationItem.title = "Information about the photo"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.titleTextAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    }

    @objc func likeOrDislike() {
        if isFavourite {
            let alert = UIAlertController(title: "Attention!", message: "Do you want to remove this photo from favorites?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) {_ in
                self.isFavourite = false
                self.buttonsChange(isFavorite: self.isFavourite)
                for index in 0..<FavoritesPhotos.favorites.count {
                    if FavoritesPhotos.favorites[index].id == self.detailedImage!.id {
                        FavoritesPhotos.favorites.remove(at: index)
                        self.delegate?.didChangeFavouritesList()
                        break
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            isFavourite = true
            buttonsChange(isFavorite: isFavourite)
            FavoritesPhotos.favorites.append(detailedImage!)
            self.delegate?.didChangeFavouritesList()
        }
    }

    private func buttonsChange(isFavorite: Bool) {
        if isFavourite {
            addToFavoriteButton.configuration?.title = "Remove from favorites 💔"
            addToFavoriteButton.configuration?.baseBackgroundColor = .systemPurple
            let image = UIImage(systemName: "heart.slash.fill")
            heartButton.configuration?.image = image
            heartButton.configuration?.baseForegroundColor = .purple
        } else {
            addToFavoriteButton.configuration?.title = "Add to favorites ❤️"
            addToFavoriteButton.configuration?.baseBackgroundColor = .systemBlue
            let image = UIImage(systemName: "heart.fill")
            heartButton.configuration?.image = image
            heartButton.configuration?.baseForegroundColor = .systemPink
        }
    }

    private func setupDate(date: String) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US")
        let showDate = inputFormatter.date(from: date)

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        let resultString = outputFormatter.string(from: showDate!)

        createdAtLabel.text = resultString
    }

    private func getPhoto() {
        networkDataFetcher?.fetchDetailedImage(id: id) { [weak self] detailedPhoto in
            guard let fetchedImage = detailedPhoto else { return }
            DispatchQueue.main.async {
                self?.detailedImage = fetchedImage
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        guard let detailedImage = detailedImage else { return }
        let imageUrl = detailedImage.urls["regular"]
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
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
        nameLabel.text = detailedImage.user.name
        locationLabel.text = "\(detailedImage.location?.city ?? "Unknown city"), \(detailedImage.location?.country ?? "Unknown country")"
        downloadsLabel.text = "Downloads count: \(detailedImage.downloads)"
        setupDate(date: detailedImage.createdAt)
        for image in FavoritesPhotos.favorites {
            if image.id == detailedImage.id {
                isFavourite = true
                buttonsChange(isFavorite: isFavourite)
            }
        }
    }
}
