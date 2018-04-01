//
//  ViewController.swift
//  DJSemiModalViewController
//
//  Created by David Jonsén on 04/01/2018.
//  Copyright (c) 2018 David Jonsén. All rights reserved.
//

import UIKit
import DJSemiModalViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func createSemiModalViewController() -> DJSemiModalViewController {

        let controller = DJSemiModalViewController()

        controller.maxWidth = 420
        controller.minHeight = 200

        controller.title = "Title"
        controller.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        controller.closeButton.setTitle("Done", for: .normal)

        let label = UILabel()
        label.text = "An example label"
        label.textAlignment = .center
        controller.addArrangedSubview(view: label)

        let imageView = UIImageView(image: #imageLiteral(resourceName: "Image"))
        imageView.contentMode = .scaleAspectFit
        controller.addArrangedSubview(view: imageView, height: 200)

        let secondLabel = UILabel()
        secondLabel.textAlignment = .center
        secondLabel.text = "Pen and Pineapple"
        controller.addArrangedSubview(view: secondLabel)

        return controller
    }

    @IBAction func actionButtonAction(_ sender: Any) {

        let controller = createSemiModalViewController()

        controller.presentOn(presentingViewController: self, animated: true, onDismiss: {
            debugPrint("`DJSemiModalViewController` dismissed")
        })
        
        debugPrint("`DJSemiModalViewController` presented")
    }
}

