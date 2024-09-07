//
//  CharactersViewController.swift
//  RickCompanion
//
//  Created by Jimmy on 03/09/2024.
//
import UIKit
import DataRepository
import SwiftUI

/// A view controller that displays a list of Rick and Morty characters.
///
/// This view controller is responsible for:
/// - Displaying a paginated list of characters
/// - Handling user interactions for character selection
/// - Managing the filtering of characters by status
///
/// It uses a `CharactersViewModel` to manage its data and business logic.
class CharactersViewController: UIViewController {
    private let coordinator: CharactersCoordinator
    private let viewModel: CharactersViewModelProtocol
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let filterView: FilterViewWrapper
    private let imageLoadingService: ImageCacheService
    private let tableViewManager: CharactersTableViewManager
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    /// Initializes a new instance of `CharactersViewController`.
    ///
    /// - Parameters:
    ///   - coordinator: The coordinator responsible for handling navigation from this view controller.
    ///   - viewModel: The view model that provides data and business logic for this view controller.
    ///   - imageLoadingService: The service responsible for loading and caching character images.
    ///   - filterViewWrapper: A wrapper for the filter view used to filter characters by status.
    init(coordinator: CharactersCoordinator,
         viewModel: CharactersViewModelProtocol,
         imageLoadingService: ImageCacheService,
         filterViewWrapper: FilterViewWrapper) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.imageLoadingService = imageLoadingService
        self.filterView = filterViewWrapper
        self.tableViewManager = CharactersTableViewManager(viewModel: viewModel,
                                                           coordinator: coordinator,
                                                           imageLoadingService: imageLoadingService)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        configureRefreshControl()
        configureFilterView()
        setupActivityIndicator()
        viewModel.delegate = self
        Task {
            await loadCharacters()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /// Sets up the main UI components of the view controller.
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// Configures the table view with necessary settings and registers cell types.
    private func configureTableView() {
        tableView.delegate = tableViewManager
        tableView.dataSource = tableViewManager
        tableView.prefetchDataSource = tableViewManager
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.tableHeaderView = createHeaderView()
    }

    /// Configures the refresh control for pull-to-refresh functionality.
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    /// Configures the filter view for character status filtering.
    private func configureFilterView() {
        filterView.onFilterSelected = { [weak self] newFilter in
            self?.viewModel.applyFilter(newFilter)
            Task {
                await self?.loadCharacters()
            }
        }
    }

    /// Sets up the activity indicator for loading states.
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /// Creates and returns the header view for the table view.
    ///
    /// - Returns: A `UIView` containing the title and filter options.
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150))
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Characters"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(filterView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            filterView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            filterView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            filterView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            filterView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            filterView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return headerView
    }

    /// Refreshes the character data.
    @objc private func refreshData() {
        viewModel.resetPagination()
        Task {
            await loadCharacters()
        }
    }

    /// Loads characters from the view model.
    private func loadCharacters() async {
        await viewModel.loadCharacters()
    }

    /// Displays an error alert to the user.
    ///
    /// - Parameter error: The error to display.
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            Task {
                await self?.loadCharacters()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    /// Shows the loading indicator and disables user interaction.
    private func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }

    /// Hides the loading indicator and enables user interaction.
    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.view.isUserInteractionEnabled = true
        }
    }
}

extension CharactersViewController: CharactersViewModelDelegate {
    func viewModelDidUpdateState(_ viewModel: CharactersViewModel, state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .idle:
                self?.tableView.reloadData()
            case .loading:
                if viewModel.characters.isEmpty {
                    self?.showLoadingIndicator()
                }
            case .loaded:
                self?.hideLoadingIndicator()
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            case .error(let error):
                self?.hideLoadingIndicator()
                self?.showError(error)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
