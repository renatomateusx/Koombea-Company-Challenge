//
//  PostUserViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit

class MainPostViewCell: UITableViewCell {
    
    static let identifier: String = "MainPostViewCell"
    typealias OnDidTapImage = ((UIImage) -> Void)
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    private let viewModel = ViewControllerViewModel()
    private var userPost: UserPosts?
    private var posts: [Post] = []
    
    // MARK: - Public Properties
    var onDidTapImage: OnDidTapImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Setup UI

extension MainPostViewCell {
    
    func setupUI() {
        tableView.isScrollEnabled = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: OneBigImageCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: OneBigImageCell.identifier)
        tableView.register(UINib(nibName: TwoSmallImagesViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: TwoSmallImagesViewCell.identifier)
        tableView.register(UINib(nibName: ThreeImagesViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: ThreeImagesViewCell.identifier)
        tableView.register(UINib(nibName: FourMoreImagesViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: FourMoreImagesViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Cell Configuration

extension MainPostViewCell {
    
    func configure(with user: UserPosts) {
        self.userPost = user
        self.posts = user.posts
        self.configureData(user)
    }
    
    func configureData(_ userPost: UserPosts) {
        self.userNameLabel.text = userPost.name
        self.userEmailLabel.text = userPost.email
        if let url = URL(string: userPost.profile_pic) {
            self.userImageView.kf.setImage(with: url)
        }
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension MainPostViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let picsCount = self.posts[indexPath.row].pics.count
        switch picsCount {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OneBigImageCell.identifier,
                                                           for: indexPath) as? OneBigImageCell else { return UITableViewCell() }
            cell.configure(with: self.posts[indexPath.row])
            cell.delegate = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TwoSmallImagesViewCell.identifier,
                                                           for: indexPath) as? TwoSmallImagesViewCell else { return UITableViewCell() }
            cell.configure(with: self.posts[indexPath.row])
            cell.delegate = self
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ThreeImagesViewCell.identifier,
                                                           for: indexPath) as? ThreeImagesViewCell else { return UITableViewCell() }
            cell.configure(with: self.posts[indexPath.row])
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FourMoreImagesViewCell.identifier,
                                                           for: indexPath) as? FourMoreImagesViewCell else { return UITableViewCell() }
            cell.configure(with: self.posts[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let picsCount = self.posts[indexPath.row].pics.count
        switch picsCount {
        case 1:
            return viewModel.oneBigImageHeight
        case 2:
            return viewModel.twoSmallImagesHeight
        case 3:
            return viewModel.threeImagesHeight
        default:
            return viewModel.fourMoreImagesHeight
        }
    }
}

// MARK: - UITableViewDelegate

extension MainPostViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - OneBigImageCellDelegate

extension MainPostViewCell: OneBigImageCellDelegate {
    func didImageViewTapped(image: UIImage) {
        self.onDidTapImage?(image)
    }
}

// MARK: - TwoSmallImagesViewCellDelegate

extension MainPostViewCell: TwoSmallImagesViewCellDelegate {
    func didTwoSmallImagesTapped(image: UIImage) {
        self.onDidTapImage?(image)
    }
}

// MARK: - ThreeImagesViewCellDelegate

extension MainPostViewCell: ThreeImagesViewCellDelegate {
    func didThreeImagesTapped(image: UIImage) {
        self.onDidTapImage?(image)
    }
}

// MARK: - FourMoreImagesViewCellDelegate

extension MainPostViewCell: FourMoreImagesViewCellDelegate {
    func didFourMoreImagesViewTapped(image: UIImage) {
        self.onDidTapImage?(image)
    }
}
