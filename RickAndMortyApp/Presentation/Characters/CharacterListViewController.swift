//
//  CharacterListViewController.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//
import UIKit
import SwiftUI

final class CharacterListViewController: UIViewController,
                                         UITableViewDelegate,
                                         UISearchBarDelegate,
                                         UITableViewDataSource {

    // MARK: - Dependencies
    private let viewModel: CharacterListViewModel
    private let episodeService: EpisodeServiceProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    private var characters: [Character] = []
    private var searchTask: Task<Void, Never>?
    private var isLoadingMore = false

    // MARK: - UI UIKit
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()

    private let statusSegmented: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["All", "Alive", "Dead", "Unknown"])
        sc.selectedSegmentIndex = 0
        return sc
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - SwiftUI Views
    private lazy var emptyStateView = UIHostingController(rootView: EmptyStateView())
    private lazy var loadingView = UIHostingController(rootView: LoadingView())

    // MARK: - INIT
    init(viewModel: CharacterListViewModel,
         episodeService: EpisodeServiceProtocol,
         favoritesRepository: FavoritesRepositoryProtocol) {

        self.viewModel = viewModel
        self.episodeService = episodeService
        self.favoritesRepository = favoritesRepository

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupUI()
        setupNavigationBar()
        setupSwiftUIViews()
        bindViewModel()

        checkConnectionAndLoad()
    }

    // MARK: - INTERNET VALIDATION
    private func checkConnectionAndLoad() {

        if NetworkMonitor.shared.isConnected {

            Task {
                await viewModel.fetchCharacters()
            }

        } else {

            showOfflineAlert()
        }
    }

    // MARK: - OFFLINE ALERT
    private func showOfflineAlert() {

        let favorites = favoritesRepository.getFavorites()

        let message: String

        if favorites.isEmpty {

            message = """
            No tienes conexión a internet y aún no tienes favoritos guardados.

            Agrega personajes a favoritos cuando tengas internet para poder visualizarlos sin conexión.
            """

        } else {

            message = """
            No tienes conexión a internet.

            Puedes visualizar tus personajes favoritos guardados.
            """
        }

        let alert = UIAlertController(
            title: "Sin conexión",
            message: message,
            preferredStyle: .alert
        )

        // Reintentar
        alert.addAction(UIAlertAction(title: "Reintentar", style: .default) { [weak self] _ in

            self?.checkConnectionAndLoad()
        })

        // Abrir favoritos offline
        if !favorites.isEmpty {

            alert.addAction(UIAlertAction(title: "Ver favoritos", style: .default) { [weak self] _ in

                guard let self else { return }

                let vc = FavoritesViewController(
                    repository: self.favoritesRepository,
                    episodeService: self.episodeService
                )

                self.navigationController?.pushViewController(vc, animated: true)
            })
        }

        present(alert, animated: true)
    }

    // MARK: - NAVIGATION
    private func setupNavigationBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Favorites",
            style: .plain,
            target: self,
            action: #selector(openFavorites)
        )
    }

    @objc private func openFavorites() {

        let vc = FavoritesViewController(
            repository: favoritesRepository,
            episodeService: episodeService
        )

        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UI SETUP
    private func setupUI() {

        title = "Characters"

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            CharacterCell.self,
            forCellReuseIdentifier: CharacterCell.identifier
        )

        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.keyboardDismissMode = .onDrag

        tableView.refreshControl = refreshControl

        refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )

        tableView.translatesAutoresizingMaskIntoConstraints = false
        statusSegmented.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(statusSegmented)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            statusSegmented.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),

            statusSegmented.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),

            statusSegmented.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),

            tableView.topAnchor.constraint(
                equalTo: statusSegmented.bottomAnchor,
                constant: 8
            ),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        statusSegmented.addTarget(
            self,
            action: #selector(statusChanged),
            for: .valueChanged
        )

        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }

    // MARK: - SWIFTUI SETUP
    private func setupSwiftUIViews() {

        addChild(emptyStateView)
        addChild(loadingView)

        view.addSubview(emptyStateView.view)
        view.addSubview(loadingView.view)

        emptyStateView.didMove(toParent: self)
        loadingView.didMove(toParent: self)

        emptyStateView.view.translatesAutoresizingMaskIntoConstraints = false
        loadingView.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            emptyStateView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emptyStateView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            loadingView.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loadingView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        updateUIState(.loading)
    }

    // MARK: - UI STATE
    private enum UIState {
        case loading
        case content
        case empty
    }

    private func updateUIState(_ state: UIState) {

        switch state {

        case .loading:

            loadingView.view.isHidden = false
            emptyStateView.view.isHidden = true
            tableView.isHidden = true

        case .content:

            loadingView.view.isHidden = true
            emptyStateView.view.isHidden = true
            tableView.isHidden = false

        case .empty:

            loadingView.view.isHidden = true
            emptyStateView.view.isHidden = false
            tableView.isHidden = true
        }
    }

    // MARK: - BIND VIEWMODEL
    private func bindViewModel() {

        viewModel.onStateChange = { [weak self] state in

            guard let self else { return }

            DispatchQueue.main.async {

                switch state {

                case .loading:

                    self.updateUIState(.loading)

                case .idle:

                    self.updateUIState(.loading)

                case .success(let characters):

                    self.characters = characters

                    self.tableView.reloadData()

                    self.refreshControl.endRefreshing()

                    self.updateUIState(
                        characters.isEmpty ? .empty : .content
                    )

                case .empty:

                    self.characters = []

                    self.tableView.reloadData()

                    self.refreshControl.endRefreshing()

                    self.updateUIState(.empty)

                case .error:

                    self.refreshControl.endRefreshing()

                    self.showOfflineAlert()
                }
            }
        }
    }

    // MARK: - ACTIONS
    @objc private func refreshData() {

        checkConnectionAndLoad()
    }

    @objc private func statusChanged() {

        let index = statusSegmented.selectedSegmentIndex

        let value: String?

        switch index {

        case 1:
            value = "alive"

        case 2:
            value = "dead"

        case 3:
            value = "unknown"

        default:
            value = nil
        }

        viewModel.updateStatus(value)

        checkConnectionAndLoad()
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        viewModel.updateFilters(name: searchText)

        searchTask?.cancel()

        searchTask = Task {

            try? await Task.sleep(nanoseconds: 300_000_000)

            guard !Task.isCancelled else { return }

            await viewModel.fetchCharacters()
        }
    }

    // MARK: - TABLE
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        characters.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.identifier,
            for: indexPath
        ) as? CharacterCell else {

            return UITableViewCell()
        }

        cell.configure(with: characters[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let character = characters[indexPath.row]

        let vm = CharacterDetailViewModel(
            character: character,
            repository: favoritesRepository,
            episodeService: episodeService
        )

        let vc = CharacterDetailViewController(viewModel: vm)

        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - PAGINATION
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        guard contentHeight > 0 else { return }
        guard !isLoadingMore else { return }

        if position > contentHeight - screenHeight - 150 {

            isLoadingMore = true

            Task {

                await viewModel.fetchCharacters()

                isLoadingMore = false
            }
        }
    }

    // MARK: - ERROR
    private func showError(_ message: String) {

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}
