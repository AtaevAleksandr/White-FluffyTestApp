//
//  DetailPhotoViewController.swift
//  White&Fluffy TestApp
//
//  Created by Aleksandr Ataev on 11.06.2023.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createBarsItems()
        navigationController?.navigationBar.layoutIfNeeded()
    }

    //MARK: - Clousers
    private lazy var addToFavorite: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "heart.fill")
        button.tintColor = .systemPink
        return button
    }()

    private lazy var deleteFromFavorite: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "heart.slash.fill")
        button.tintColor = .systemPink
        return button
    }()

    //MARK: - Methods
    private func createBarsItems() {
        navigationItem.title = "Information about the photo"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.titleTextAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationItem.rightBarButtonItems = [deleteFromFavorite, addToFavorite]
    }

    @objc func addTapped() {
        // Обработчик для кнопки 1
    }

    @objc func deleteTapped() {
        // Обработчик для кнопки 2
    }

}
