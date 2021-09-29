//
//  FourMoreImagesViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus on 27/09/21.
//

import UIKit

protocol FourMoreImagesViewCellDelegate: AnyObject {
    func didFourMoreImagesViewTapped(image: UIImage)
}

class FourMoreImagesViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier: String = "FourMoreImagesViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private Properties
    weak var delegate: FourMoreImagesViewCellDelegate?
    private var pics: [String] = []
    private var post: Post? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Setup UI

extension FourMoreImagesViewCell {
    func setupUI() {
        collectionView.backgroundColor = .purple
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: PictureViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: PictureViewCell.identifier)
        
        let spacing: CGFloat = 12
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Setup Data

extension FourMoreImagesViewCell {
    func setupData() {
        self.pics = []
        let date = Date()
        if let postedDate = self.post?.date {
            self.postDateLabel.text = date.getDate(dateString: postedDate)
        }
        if let imagePic = self.post?.pics[0],
           let url = URL(string: imagePic) {
            self.postImageView.kf.setImage(with: url)
            self.configureImageTapped()
        }
        if let picsCount = self.post?.pics.count {
            for i in (0...picsCount-1) {
                if let pic = self.post?.pics[i] {
                    self.pics.append(pic)
                }
            }
            collectionView.reloadData()
        }
    }
}

// MARK: - Cell Configuration

extension FourMoreImagesViewCell {
    func configureImageTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedImage(tapGesture:)))
        self.postImageView.isUserInteractionEnabled = true
        self.postImageView.addGestureRecognizer(tap)
    }
    
    func configure(with post: Post) {
        self.post = post
    }
}

// MARK: - CollectionViewDataSource

extension FourMoreImagesViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pic = self.pics[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureViewCell.identifier,
                                                            for: indexPath) as? PictureViewCell  else { return  UICollectionViewCell() }
        cell.configure(with: pic)
        cell.onDidPictureTapped = { [weak self] image in
            guard let self = self else { return }
            self.delegate?.didFourMoreImagesViewTapped(image: image)
        }
        return cell
    }
}

// MARK: - UICollectionViewLayout

extension FourMoreImagesViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 132, height: 132)
    }
}

// MARK: - Actions

extension FourMoreImagesViewCell {
    @objc func didTappedImage(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        if let image = imageView.image {
            self.delegate?.didFourMoreImagesViewTapped(image: image)
        }
    }
}
