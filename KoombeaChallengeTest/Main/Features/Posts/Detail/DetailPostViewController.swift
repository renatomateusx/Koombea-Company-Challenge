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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        afterInit()
    }
    
    func setupUI() {
        let swipeDown = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(respondToSwipeGesture))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
        self.detailPostImageView.image = image
    }
    
    func afterInit() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = UIVisualEffectView(effect: blurEffect)
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(customBlurEffectView, at: 0)
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

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .down:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
