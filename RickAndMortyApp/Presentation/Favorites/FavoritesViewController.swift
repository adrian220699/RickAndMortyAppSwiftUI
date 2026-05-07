//
//  FavoritesViewController.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//
import UIKit
import SwiftUI

final class FavoritesViewController: UIViewController {

    private var characters: [Character] = []

    private let repository: FavoritesRepositoryProtocol
    private let episodeService: EpisodeServiceProtocol

    private var isAuthenticated = false

    private var hostingController: UIHostingController<AnyView>?

    // MARK: - INIT

    init(repository: FavoritesRepositoryProtocol,
         episodeService: EpisodeServiceProtocol) {

        self.repository = repository
        self.episodeService = episodeService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        view.backgroundColor = .systemBackground

        authenticateUser()
    }

    // MARK: - REFRESH AL REGRESAR

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard isAuthenticated else { return }

        refreshFavorites()
    }

    // MARK: - BIOMETRÍA

    private func authenticateUser() {

        BiometricManager.shared.authenticate { [weak self] success in

            guard let self else { return }

            DispatchQueue.main.async {

                if success {
                    self.isAuthenticated = true
                    self.loadFavorites()
                } else {
                    self.showAccessDenied()
                }
            }
        }
    }

    // MARK: - LOAD FAVORITES

    private func loadFavorites() {
        refreshFavorites()
    }

    // MARK: - REFRESH FAVORITES

    private func refreshFavorites() {

        characters = repository.getFavorites()

        let swiftUIView = FavoritesListView(
            characters: characters,
            onSelect: { [weak self] character in
                self?.openDetail(character)
            }
        )

        showSwiftUI(swiftUIView)
    }

    // MARK: - SWIFTUI HOST

    private func showSwiftUI<V: View>(_ swiftUIView: V) {

        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()

        let host = UIHostingController(rootView: AnyView(swiftUIView))
        hostingController = host

        addChild(host)
        self.view.addSubview(host.view)
        host.didMove(toParent: self)

        host.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    // MARK: - ACCESS DENIED

    private func showAccessDenied() {

        showSwiftUI(AccessDeniedView())
    }

    // MARK: - NAVIGATION

    private func openDetail(_ character: Character) {

        let vm = CharacterDetailViewModel(
            character: character,
            repository: repository,
            episodeService: episodeService
        )

        let vc = CharacterDetailViewController(viewModel: vm)

        navigationController?.pushViewController(vc, animated: true)
    }
}
