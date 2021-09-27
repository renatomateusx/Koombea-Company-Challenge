//
//  PictureViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit

class PictureViewCell: UICollectionViewCell {
    
    typealias OnDidPictureTapped = ((UIImage) -> Void)
    
    // MARK: - Private Properties
    static let identifier: String = "PictureViewCell"
    
    // MARK: - Public Properties
    var onDidPictureTapped: OnDidPictureTapped?
    
    // MARK: - Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemPink
    }
}

extension PictureViewCell {
    func configure(with pic: String) {
        if let url = URL(string: pic) {
            self.pictureImageView.kf.setImage(with: url)
            self.configureImageTapped()
        }
    }
}

extension PictureViewCell {
    func configureImageTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedImage(tapGesture:)))
        self.pictureImageView.isUserInteractionEnabled = true
        self.pictureImageView.addGestureRecognizer(tap)
    }
    
    @objc func didTappedImage(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        if let image = imageView.image {
            self.onDidPictureTapped?(image)
        }
    }
}
