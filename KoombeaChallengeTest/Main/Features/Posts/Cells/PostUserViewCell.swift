//
//  PostUserViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit

class PostUserViewCell: UITableViewCell {
    
    static let identifier: String = "PostUserViewCell"
    typealias OnDidTapImage = ((UIImageView) -> Void)
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postedDateLabel: UILabel!
    
    // MARK: - Private Properties
    private var userPost: UserPosts?
    private var showTop: Bool = false
    private var posts: [Post] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Public Properties
    var onDidTapImage: OnDidTapImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: PostTableViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: PostTableViewCell.identifier)
        
        let spacing: CGFloat = 12
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureData(_ userPost: UserPosts) {
        self.userNameLabel.text = userPost.name
        self.userEmailLabel.text = userPost.email
        if let url = URL(string: userPost.profile_pic) {
            self.userImageView.kf.setImage(with: url)
        }
    }
}

extension PostUserViewCell: UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostTableViewCell.identifier,
                                                            for: indexPath) as? PostTableViewCell,
              let userPost = self.userPost else { return  UICollectionViewCell() }
        self.configureData(userPost)
        cell.configure(with: userPost, and: self.posts[indexPath.row], showTop)
        cell.onDidImageTapped = { [weak self] imageView in
            self?.onDidTapImage?(imageView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picsCount = self.posts[indexPath.row].pics.count
        let width = collectionView.frame.size.width
        switch picsCount {
        case 1:
            return CGSize(width: width, height: 750)
        case 2:
            return CGSize(width: width, height: 750)
        default:
            return CGSize(width: width, height: 750)
        }
        
    }
}

extension PostUserViewCell {
    func configure(with user: UserPosts, _ showTop: Bool) {
        self.userPost = user
        self.posts = user.posts
        self.showTop = showTop
    }
}
