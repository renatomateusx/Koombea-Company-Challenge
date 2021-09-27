//
//  OneBigImageCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus on 27/09/21.
//

import UIKit

protocol OneBigImageCellDelegate: AnyObject {
    func didImageViewTapped(image: UIImage)
}

class OneBigImageCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier: String = "OneBigImageCell"

    // MARK: - Outlets
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    // MARK: - Private Properties
    weak var delegate: OneBigImageCellDelegate?
    private var post: Post? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension OneBigImageCell {
    func configure(with post: Post) {
        self.post = post
    }
    
    func setupData() {
        let date = Date()
        if let postedDate = self.post?.date {
            self.postDateLabel.text = date.getDate(dateString: postedDate)
        }
        if let imagePic = self.post?.pics[0],
           let url = URL(string: imagePic) {
            self.postImageView.kf.setImage(with: url)
            self.configureImageTapped()
        }
    }
}

// MARK: - Actions

extension OneBigImageCell {
    func configureImageTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedImage(tapGesture:)))
        self.postImageView.isUserInteractionEnabled = true
        self.postImageView.addGestureRecognizer(tap)
    }
    
    @objc func didTappedImage(tapGesture: UITapGestureRecognizer) {
        let imageView = tapGesture.view as! UIImageView
        if let image = imageView.image {
            self.delegate?.didImageViewTapped(image: image)
        }
    }
}
