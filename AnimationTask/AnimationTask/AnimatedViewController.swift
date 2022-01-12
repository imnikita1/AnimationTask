//
//  AnimatedViewController.swift
//  AnimationTask
//
//  Created by CMDB-127710 on 11.01.2022.
//

import UIKit

protocol AnimatedViewControllerDelegate: AnyObject {
    func animateWithFrame()
}

class AnimatedViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var goBackButton: UIButton!
    
    weak var delegate: AnimatedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        goBackButton.tintColor = .white
        goBackButton.backgroundColor = .systemBlue
        goBackButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        delegate?.animateWithFrame()
        navigationController?.popViewController(animated: true)
    }
    
}
