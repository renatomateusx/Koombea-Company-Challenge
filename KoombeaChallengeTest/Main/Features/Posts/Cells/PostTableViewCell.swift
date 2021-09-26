//
//  OnePicPostUserTableViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit
import Kingfisher

class PostTableViewCell: UICollectionViewCell {
    
    static let identifier: String = "PostTableViewCell"
    typealias OnDidImageTapped = ((UIImageView) -> Void)

    // MARK: - Outlets
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var twoImages: UIStackView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var threeOrMoreImagesStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postImageStackView: UIStackView!
    @IBOutlet weak var postDateLabel: UILabel!
    
    @IBOutlet weak var userDataContainerView: UIView!
    // MARK: - Private Properties
    private var pics: [String] = []
    
    // MARK: - Public Properties
    var onDidImageTapped: OnDidImageTapped?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Helper

extension PostTableViewCell {
    func setupUI() {
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: PictureViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: PictureViewCell.identifier)
        
        let spacing: CGFloat = 0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImageView(tapGestureRecognizer:)))
        self.postImageView.isUserInteractionEnabled = true
        self.postImageView.addGestureRecognizer(tap)
    }
    
    func configure(with user: UserPosts, and post: Post, _ showTop: Bool) {
        let date = Date()
        postDateLabel.text = date.getDate(dateString: post.date)
        let picsCount = user.posts.reduce(0) { $0 + $1.pics.count }
        switch picsCount {
        case 1:
            print("one pic")
            self.firstImageView.isHidden = true
            self.secondImageView.isHidden = true
            self.postImageView.isHidden = false
            self.collectionView.isHidden = true
            
            if let url = URL(string: post.pics[0]) {
                self.postImageView.kf.setImage(with: url)
            }
            
        case 2:
            print("two pics")
            self.firstImageView.isHidden = false
            self.secondImageView.isHidden = false
            self.postImageView.isHidden = true
            self.collectionView.isHidden = true
            if let url1 = URL(string: post.pics[0]) {
                self.firstImageView.kf.setImage(with: url1)
            }
            
            if let url2 = URL(string: post.pics[1]) {
                self.secondImageView.kf.setImage(with: url2)
            }
        default:
            if post.pics.count >= 3 {
                print("three or more pics")
                self.firstImageView.isHidden = true
                self.secondImageView.isHidden = true
                self.postImageView.isHidden = false
                self.collectionView.isHidden = false
                if let url = URL(string: post.pics[0]) {
                    self.postImageView.kf.setImage(with: url)
                }
                for i in (1...post.pics.count - 1) {
                    self.pics.append(post.pics[i])
                }
                collectionView.reloadData()
            }
        }
    }
}

// MARK: - CollectionView

extension PostTableViewCell: UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pic = self.pics[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureViewCell.identifier,
                                                            for: indexPath) as? PictureViewCell  else { return  UICollectionViewCell() }
        cell.configure(with: pic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 171, height: 171)
    }
}


// MARK: - Actions

extension PostTableViewCell {
    @objc func didTapImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.onDidImageTapped?(tappedImage)
    }
}
