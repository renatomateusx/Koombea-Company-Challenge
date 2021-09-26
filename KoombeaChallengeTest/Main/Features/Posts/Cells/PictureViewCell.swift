//
//  PictureViewCell.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit

class PictureViewCell: UICollectionViewCell {
    
    static let identifier: String = "PictureViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension PictureViewCell {
    func configure(with pic: String) {
        if let url = URL(string: pic) {
            self.pictureImageView.kf.setImage(with: url)
        }
    }
}
