//
//  ViewController.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    internal let viewModel = ViewControllerViewModel(with: PostsService())
    private var dataSource: [UserPosts] = []
    private var posts: [Post] = []
    private var lastUpdated: String?
    private let refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
}

// MARK: - setupUI

extension ViewController {
    func setupUI() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: MainPostViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: MainPostViewCell.identifier)
        tableView.register(UINib(nibName: TableHeaderView.identifier,
                                 bundle: nil),
                           forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)
        
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        
        refreshControl.addTarget(self,
                                 action: #selector(self.refresh(_:)),
                                 for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - SetupData

extension ViewController {
    func setupData() {
        viewModel.delegate = self
        if dataSource.isEmpty {
            tableView.showLoading()
        }
        
        viewModel.fetchPosts()
    }
}

// MARK: - ViewControllerViewModelDelegate

extension ViewController: ViewControllerViewModelDelegate {
    func onSuccessFetchingPost(posts: [UserPosts], lastUpdated: Double) {
        self.dataSource = posts
        self.lastUpdated = self.getDate(sinceTime: lastUpdated)
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        if viewModel.isOffLine {
            self.showToast(message: "You're running offline",
                           font: .systemFont(ofSize: 16, weight: .bold))
        }
    }
    
    func onFailureFetchingPost(error: Error) {
        self.tableView.backgroundView = self.getEmptyView()
    }
}

// MARK: - TableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userPost = self.dataSource[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainPostViewCell.identifier,
                                                       for: indexPath) as? MainPostViewCell else { return UITableViewCell() }
        cell.configure(with: userPost)
        cell.onDidTapImage = { [weak self] imageView in
            guard let self = self else { return }
            let vc = DetailPostViewController(with: imageView)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            if let navigationController = self.navigationController {
                navigationController.present(vc, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let userPost = self.dataSource[indexPath.row]
        let height = viewModel.calculateCell(userPost: userPost)
        return height
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.isOffLine {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier) as? TableHeaderView else { return nil }
            header.configure(with: self.lastUpdated ?? "")
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.isOffLine {
            return 65
        }
        return 0
    }
}

// MARK: - Helpers

private extension ViewController {
    func getEmptyView() -> UIView {
        
        let labelDescription: UILabel = UILabel()
        labelDescription.font = .systemFont(ofSize: 20, weight: .regular)
        labelDescription.textColor = UIColor.darkGray
        labelDescription.numberOfLines = 0
        labelDescription.textAlignment = .center
        labelDescription.text = "Looks like that you don't have internet. \nPlease check it out and pull to refresh."
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.sizeToFit()
        
        return labelDescription
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 10,
                                               y: 80,
                                               width: self.view.frame.size.width - 20,
                                               height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        toastLabel.alpha = 0.0
                       }, completion: {(isCompleted) in
                        toastLabel.removeFromSuperview()
                       })
    }
    
    func getDate(sinceTime: Double) -> String {
        let date = Date(timeIntervalSince1970: sinceTime)
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .medium
        let dateString = dateFormater.string(from: date)
        return dateString
    }
}

// MARK: - Actions

private extension ViewController {
    @objc func refresh(_ sender: AnyObject) {
        viewModel.fetchPosts()
    }
}
