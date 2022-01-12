//
//  ViewController.swift
//  AnimationTask
//
//  Created by CMDB-127710 on 11.01.2022.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    
    @IBOutlet weak var nextScreenButton: UIButton!
    
    let rotationAnimation = RotationAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        setupNavigationBar()
        setupNextScreenButton()
    }

    fileprivate func setupNavigationBar() {
        title = "First screen"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.black]

        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    fileprivate func setupNextScreenButton() {
        nextScreenButton.setTitle("Animate!!!", for: .normal)
        nextScreenButton.titleLabel?.font = .systemFont(ofSize: 35)
        nextScreenButton.tintColor = .white
        nextScreenButton.backgroundColor = .systemBlue
        nextScreenButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func nextScreenButtonPressed(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AnimatedViewController") as! AnimatedViewController
        viewController.delegate = rotationAnimation
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK: UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        rotationAnimation.operation = operation
        return rotationAnimation
    }
}



