//
//  CelulaAmaralRenatinhoCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus on 28/09/21.
//

import UIKit

class CelulaAmaralRenatinhoCell: UITableViewCell {
    static let identifier: String = "CelulaAmaralRenatinhoCell"
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var firstImageHeightConstraint: NSLayoutConstraint!
    
    private var pics: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CelulaAmaralRenatinhoCell {
    func fill(with post: Post) {
        self.pics = []
        collectionView.reloadData()
        
        if let url = URL(string: post.pics[0]) {
            self.firstImageView.kf.setImage(with: url)
            self.firstImageView.isHidden = false
            collectionView.isHidden = true
            self.firstImageHeightConstraint.constant = self.firstImageView.frame.width
        }
        if post.pics.count == 2 {
            guard let url = URL(string: post.pics[1]) else { return }
            self.secondImageView.kf.setImage(with: url)
            self.secondImageView.isHidden = false
            self.firstImageHeightConstraint.constant = self.firstImageView.frame.width
        } else if post.pics.count > 2 {
            collectionView.isHidden = false
            let picsCount = post.pics.count
            for i in (0...picsCount-1) {
                self.pics.append(post.pics[i])
            }
            setupUI()
            collectionView.reloadData()
        }

    }
}

// MARK: - Setup UI

extension CelulaAmaralRenatinhoCell {
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

extension CelulaAmaralRenatinhoCell {
    func setupData() {
//        let date = Date()
//        if let postedDate = self.post?.date {
//            self.postDateLabel.text = date.getDate(dateString: postedDate)
//        }
//        if let imagePic = self.post?.pics[0],
//           let url = URL(string: imagePic) {
//            self.postImageView.kf.setImage(with: url)
//            self.configureImageTapped()
//        }
//        if let picsCount = self.post?.pics.count {
//            for i in (0...picsCount-1) {
//                if let pic = self.post?.pics[i] {
//                    self.pics.append(pic)
//                }
//            }
//            collectionView.reloadData()
//        }
    }
}

// MARK: - Cell Configuration

extension CelulaAmaralRenatinhoCell {
    func configureImageTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedImage(tapGesture:)))
//        self.postImageView.isUserInteractionEnabled = true
//        self.postImageView.addGestureRecognizer(tap)
    }
    
    func configure(with post: Post) {
//        self.post = post
    }
}

// MARK: - CollectionViewDataSource

extension CelulaAmaralRenatinhoCell: UICollectionViewDataSource {
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
//            self.delegate?.didFourMoreImagesViewTapped(image: image)
        }
        return cell
    }
}

// MARK: - UICollectionViewLayout

extension CelulaAmaralRenatinhoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 132, height: 132)
    }
}

// MARK: - Actions

extension CelulaAmaralRenatinhoCell {
    @objc func didTappedImage(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        if let image = imageView.image {
//            self.delegate?.didFourMoreImagesViewTapped(image: image)
        }
    }
}
