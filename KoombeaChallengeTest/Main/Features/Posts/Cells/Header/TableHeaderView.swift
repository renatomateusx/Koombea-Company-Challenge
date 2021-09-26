//
//  TableHeaderView.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 26/09/21.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    static let identifier: String = "TableHeaderView"
    
    // MARK: - Outlets
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }
}

extension TableHeaderView {
    func configure(with data: String) {
        lastUpdateLabel.text = "Last updated: \(data)"
    }
}
