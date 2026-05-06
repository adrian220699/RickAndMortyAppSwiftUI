//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import UIKit
import SwiftUI

final class CharacterDetailViewController: UIViewController {

    private let viewModel: CharacterDetailViewModel

    private var hostingController: UIHostingController<CharacterDetailSwiftUIView>?

    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupHostingController()
        loadEpisodes()
    }

    // MARK: - SOLO 1 VEZ
    private func setupHostingController() {

        let host = UIHostingController(rootView: makeSwiftUIView())
        hostingController = host

        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)

        host.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - SWIFTUI VIEW
    private func makeSwiftUIView() -> CharacterDetailSwiftUIView {

        CharacterDetailSwiftUIView(
            viewModel: viewModel,
            onToggleFavorite: { [weak self] in
                self?.viewModel.toggleFavorite()
            },
            onToggleEpisode: { [weak self] index in
                self?.viewModel.toggleWatched(at: index)
            },
            onOpenMap: { [weak self] in
                self?.openMap()
            }
        )
    }

    // MARK: - LOAD DATA
    private func loadEpisodes() {

        Task {
            await viewModel.fetchEpisodes()
            await MainActor.run {
                self.refreshUI()
            }
        }
    }

    // MARK: - REFRESH SAFE (NO RECREATE ROOTVIEW)
    private func refreshUI() {
        // SOLO esto es seguro si NO usas @ObservableObject
        hostingController?.rootView = makeSwiftUIView()
    }

    // MARK: - MAP
    private func openMap() {

        let vc = CharacterMapViewController(
            characters: [viewModel.characterData]
        )

        navigationController?.pushViewController(vc, animated: true)
    }
    
}
