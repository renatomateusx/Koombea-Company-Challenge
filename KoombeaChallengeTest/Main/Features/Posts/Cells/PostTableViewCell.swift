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
    typealias OnDidImageTapped = ((UIImage) -> Void)

    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var heightPostBigImageView: NSLayoutConstraint!
    @IBOutlet weak var twoImagesStackView: UIStackView!
    @IBOutlet weak var threeMoreImagesStackView: UIStackView!
    
    
    // MARK: - Private Properties
    private var pics: [String] = []
    private var tapBig = UITapGestureRecognizer()
    private var tapFirst = UITapGestureRecognizer()
    private var tapSecond = UITapGestureRecognizer()
    
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
        
        self.postImageView.isUserInteractionEnabled = true
        self.postImageView.addGestureRecognizer(tapBig)
        self.firstImageView.isUserInteractionEnabled = true
        self.firstImageView.addGestureRecognizer(tapFirst)
        self.secondImageView.isUserInteractionEnabled = true
        self.secondImageView.addGestureRecognizer(tapSecond)
    }
    
    func configure(with user: UserPosts, and post: Post, _ showTop: Bool) {
        let date = Date()
        postDateLabel.text = date.getDate(dateString: post.date)
        let picsCount = post.pics.count
        switch picsCount {
        case 1:
            self.twoImagesStackView.isHidden = true
            self.heightPostBigImageView.constant = 353
            self.postImageView.isHidden = false
            self.threeMoreImagesStackView.isHidden = true
            
            if let url = URL(string: post.pics[0]) {
                self.postImageView.kf.setImage(with: url)
                self.configureTapImage(for: self.postImageView, with: post.pics[0])
            }
            
        case 2:
            self.twoImagesStackView.isHidden = false
            self.postImageView.isHidden = true
            self.threeMoreImagesStackView.isHidden = true
            self.heightPostBigImageView.constant = 0
            
            if let url1 = URL(string: post.pics[0]) {
                self.firstImageView.kf.setImage(with: url1)
                self.configureTapImage(for: self.firstImageView, with: post.pics[0])
            }
            
            if let url2 = URL(string: post.pics[1]) {
                self.secondImageView.kf.setImage(with: url2)
                self.configureTapImage(for: self.secondImageView, with: post.pics[1])
            }
        case 3:
            self.twoImagesStackView.isHidden = false
            self.postImageView.isHidden = false
            self.threeMoreImagesStackView.isHidden = true
            self.heightPostBigImageView.constant = 0
            
            if let url1 = URL(string: post.pics[1]) {
                self.firstImageView.kf.setImage(with: url1)
                self.configureTapImage(for: self.firstImageView, with: post.pics[0])
            }
            
            if let url2 = URL(string: post.pics[2]) {
                self.secondImageView.kf.setImage(with: url2)
                self.configureTapImage(for: self.secondImageView, with: post.pics[1])
            }
            
            if let url3 = URL(string: post.pics[0]) {
                self.postImageView.kf.setImage(with: url3)
                self.configureTapImage(for: self.postImageView, with: post.pics[0])
            }
        default:
            if picsCount >= 3 {
                self.twoImagesStackView.isHidden = true
                self.postImageView.isHidden = false
                self.heightPostBigImageView.constant = 353
                self.threeMoreImagesStackView.isHidden = false
                
                if let url = URL(string: post.pics[0]) {
                    self.postImageView.kf.setImage(with: url)
                    self.configureTapImage(for: self.postImageView, with: post.pics[0])
                }
                for i in (0...picsCount-1) {
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
        return CGSize(width: 132, height: 132)
    }
}


// MARK: - Actions

extension PostTableViewCell {
    #warning("TODO: Needs to improve here")
    func configureTapImage(for imageView: UIImageView, with url: String) {
        let tapImage = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImageView(tapGesture:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapImage)
    }
    
    @objc func didTapImageView(tapGesture: UITapGestureRecognizer) {
        let image = tapGesture.view as! UIImageView
        if let image = image.image {
            self.onDidImageTapped?(image)
        }
    }
}
