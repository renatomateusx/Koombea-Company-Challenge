//
//  ThreeImagesViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus on 27/09/21.
//

import UIKit

protocol ThreeImagesViewCellDelegate: AnyObject {
    func didThreeImagesTapped(image: UIImage)
}

class ThreeImagesViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier: String = "ThreeImagesViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    // MARK: - Private Properties
    weak var delegate: ThreeImagesViewCellDelegate?
    private var post: Post? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Setup Data

extension ThreeImagesViewCell {
    func setupData() {
        let date = Date()
        if let postedDate = self.post?.date {
            self.postDateLabel.text = date.getDate(dateString: postedDate)
        }
        if let imagePic = self.post?.pics[0],
           let url = URL(string: imagePic) {
            self.postImageView.kf.setImage(with: url)
            self.configureImageTapped(self.postImageView)
        }
        
        if let imagePic2 = self.post?.pics[2],
           let url = URL(string: imagePic2) {
            self.firstImageView.kf.setImage(with: url)
            self.configureImageTapped(self.firstImageView)
        }
        
        if let imagePic3 = self.post?.pics[2],
           let url = URL(string: imagePic3) {
            self.secondImageView.kf.setImage(with: url)
            self.configureImageTapped(self.secondImageView)
        }
    }
}

// MARK: - Cell Configuration

extension ThreeImagesViewCell {
    func configure(with post: Post) {
        self.post = post
    }
    
    func configureImageTapped(_ imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTappedImage(tapGesture:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
}

// MARK: - Actions

extension ThreeImagesViewCell {
    @objc func didTappedImage(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        if let image = imageView.image {
            self.delegate?.didThreeImagesTapped(image: image)
        }
    }
}
