//
//  FolioViewHighlighterViewController.swift
//  SberbankVS
//
//  Created by Ilya Biltuev on 31/07/2018.
//  Copyright © 2018 Mobile Up. All rights reserved.
//

import UIKit

private let buttonHeight: CGFloat = 48
private let minInset: CGFloat = 100
private let inset: CGFloat = 24

@available(iOS 9, *)
internal class FolioViewHighlighterViewController: UIViewController {
    
    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red: 0.22, green: 0.60, blue: 0.33, alpha: 1)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private var viewForHighlight: UIView!
    private var viewPosition: CGRect!
    private var borderWidth: CGFloat!
    private var borderColor: UIColor!
    private var titleText: String? = nil
    private var descriptionText: String? = nil
    private var backHighlightedView = UIView()
    private var completionBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureViews()
    }

    @IBAction private func okeyButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: completionBlock)
    }

    private func addViews() {
        [blurView, backHighlightedView, viewForHighlight, button, labelsStackView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            guard let subview = $0 else { return }
            view.addSubview(subview)
        }
        
        button.setTitle("Ок", for: .normal)
        button.addTarget(self, action: #selector(okeyButtonTouched), for: .touchUpInside)
        
        if titleText?.isEmpty == false {
            titleLabel.text = titleText
            labelsStackView.addArrangedSubview(titleLabel)
        }
        
        if descriptionText?.isEmpty == false {
            descriptionLabel.text = descriptionText
            labelsStackView.addArrangedSubview(descriptionLabel)
        }
    }
    
    private func configureViews() {
        viewForHighlight.isUserInteractionEnabled = false
        viewForHighlight.frame = viewPosition
        backHighlightedView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: viewPosition.width + borderWidth * 2,
                                           height: viewPosition.height + borderWidth * 2)
        backHighlightedView.center = viewForHighlight.center
        backHighlightedView.layer.cornerRadius = backHighlightedView.frame.height / 2
        backHighlightedView.layer.borderColor = borderColor.cgColor
        backHighlightedView.layer.borderWidth = borderWidth
        
        let viewBottomDistance = UIScreen.main.bounds.height - (viewPosition.origin.y + viewPosition.height)
        let bottomButtonConstraintConst: CGFloat
        let bottomLabelsConstraintConst: CGFloat
        if minInset > viewBottomDistance {
            bottomButtonConstraintConst = UIScreen.main.bounds.height - (viewPosition.origin.y - inset)
            bottomLabelsConstraintConst = UIScreen.main.bounds.height - (viewPosition.origin.y - (inset * 2) - buttonHeight)
        } else {
            bottomLabelsConstraintConst = UIScreen.main.bounds.height - (viewPosition.origin.y - (inset * 2))
            bottomButtonConstraintConst = (viewBottomDistance / 2) - (buttonHeight / 2)
        }
        
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.widthAnchor.constraint(equalToConstant: 204).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomButtonConstraintConst).isActive = true
        
        labelsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        labelsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        labelsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomLabelsConstraintConst).isActive = true
    }

    static func present(_ viewControllerToPresent: UIViewController,
                        viewForHighlight: UIView,
                        title: String? = nil,
                        description: String? = nil,
                        borderWidth: CGFloat = 0,
                        borderColor: UIColor = .white,
                        delay: Double = 0,
                        completion: (() -> Void)? = nil) {

        let vc = FolioViewHighlighterViewController()
        vc.viewForHighlight = viewForHighlight.snapshotView(afterScreenUpdates: false)
        vc.borderWidth = borderWidth
        vc.viewPosition = viewForHighlight.superview!.convert(viewForHighlight.frame, to: nil)
        vc.borderColor = borderColor
        vc.titleText = title
        vc.descriptionText = description
        vc.completionBlock = completion
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            viewControllerToPresent.present(vc, animated: true)
        }
    }
}

var isFontsMenuHighlightShown: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "fontsMenuHighlightShown")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "fontsMenuHighlightShown")
    }
}
