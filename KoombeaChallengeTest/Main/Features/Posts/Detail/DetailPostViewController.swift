//
//  DetailPostViewController.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import UIKit

class DetailPostViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var detailPostImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    
    private let image: UIImage
    
    // MARK: - Inits
    init(with image: UIImage) {
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        afterInit()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupUI() {
        let swipeDown = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(respondToSwipeGesture))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
        self.detailPostImageView.image = image
    }
    
    func afterInit() {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(customBlurEffectView, at: 0)
        
        /// - Constraints
        NSLayoutConstraint.activate([
            customBlurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            customBlurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customBlurEffectView.heightAnchor.constraint(equalTo: view.heightAnchor),
            customBlurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension DetailPostViewController {
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer,
           case .down = swipeGesture.direction {
                self.dismiss(animated: true, completion: nil)
        }
    }
}
