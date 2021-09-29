//
//  TwoSmallImagesViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus on 27/09/21.
//

import UIKit

protocol TwoSmallImagesViewCellDelegate: AnyObject {
    func didTwoSmallImagesTapped(image: UIImage)
}

class TwoSmallImagesViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier: String = "TwoSmallImagesViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    // MARK: - Private Properties
    weak var delegate: TwoSmallImagesViewCellDelegate?
    private var post: Post? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .green
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Setup Data

extension TwoSmallImagesViewCell {
    func setupData() {
        let date = Date()
        if let postedDate = self.post?.date {
            self.postDateLabel.text = date.getDate(dateString: postedDate)
        }
        if let firstPic = self.post?.pics[0],
           let url = URL(string: firstPic) {
            self.firstImageView.kf.setImage(with: url)
            self.configureImageTapped(self.firstImageView)
        }
        
        if let secondPic = self.post?.pics[1],
           let url = URL(string: secondPic) {
            self.secondImageView.kf.setImage(with: url)
            self.configureImageTapped(self.secondImageView)
        }
    }
}

// MARK: - Cell Configuration

extension TwoSmallImagesViewCell {
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

extension TwoSmallImagesViewCell {
    
    @objc func didTappedImage(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        if let image = imageView.image {
            self.delegate?.didTwoSmallImagesTapped(image: image)
        }
    }
}
