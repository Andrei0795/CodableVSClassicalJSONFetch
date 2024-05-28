//
//  ViewController.swift
//  CodableVSClassicalJSONFetch
//
//  Created by Andrei Ionescu on 28.05.2024.
//

import UIKit
import Combine

class ViewControllerCodable: UITableViewController {
    @IBOutlet var statusLabel: UILabel!
    var viewModel: ViewModel!
    lazy var dataSource = configureDataSource()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 110.0
        tableView.rowHeight = UITableView.automaticDimension
        
        statusLabel.text = viewModel.hasInternetConnection ? "Online Version Codable" : "Offline Version (Codable)"
        
        viewModel.updateTableView.sink { [weak self] hasInternetConnection in
            self?.updateSnapshot()
        }.store(in: &cancellables)
        viewModel.getFilms()
    }

    //Codable Version
    func configureDataSource() -> UITableViewDiffableDataSource<TableSection, Film> {
        let cellIdentifier = "Cell"

        let dataSource = UITableViewDiffableDataSource<TableSection, Film>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, film in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FilmCell

                cell.titleLabel.text = film.title
                cell.genreLabel.text = film.genre
                cell.yearLabel.text = film.year
                cell.runtimeLabel.text = film.runtime
                cell.countriesLabel.text = film.country1
                if let country2 = film.country2 {
                    cell.countriesLabel.text! += "; " + country2
                }

                return cell
            }
        )

        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {

        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Film>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.films, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }

}

