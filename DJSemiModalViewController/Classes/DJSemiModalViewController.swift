//
//  DJSemiModalViewController.swift
//  DJSemiModalViewController
//
//  Created by David Jonsén on 2018-04-01.
//  Copyright © 2018 David Jonsén. All rights reserved.
//

import UIKit

open class DJSemiModalViewController: UIViewController {

    //    MARK: Private Properties

    private lazy var backgroundCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var contentViewOriginalCenter: CGPoint?

    private lazy var contentViewMinimumHeightLayoutConstraint: NSLayoutConstraint = {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
    }()

    private lazy var contentViewMaximumHeightLayoutConstraint: NSLayoutConstraint = {
        contentView.heightAnchor.constraint(lessThanOrEqualToConstant: self.view.bounds.height - 20)
    }()

    private lazy var contentViewMaximumWidthLayoutConstraint: NSLayoutConstraint = {
        let constraint  = contentView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        constraint.priority = UILayoutPriority.init(999)
        return constraint
    }()

    private lazy var scrollViewHeightLayoutConstraint: NSLayoutConstraint = {
        scrollView.heightAnchor.constraint(equalToConstant: 0)
    }()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 6
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var viewWillDismissHandler: ViewWillDismiss?

    //    MARK: Public Properties

    public typealias ViewWillDismiss = () -> Void

    /**
     * Adjust content height automatically
     */
    public var automaticallyAdjustsContentHeight: Bool = true

    /**
     * The title label for the view
     */
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /**
     * The close button for the view
     */
    public let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 208.0 / 255.0, green: 208.0 / 255.0, blue: 214.0 / 255.0, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /**
     * Set the minimum height for the view
     */
    public var minHeight: CGFloat = 200 {
        didSet {
            contentViewMinimumHeightLayoutConstraint.constant = minHeight
        }
    }

    /**
     * Set the maximum with for the view
     */
    public var maxWidth: CGFloat = 370 {
        didSet {
            contentViewMaximumWidthLayoutConstraint.constant = maxWidth
        }
    }

    //    MARK: - Setup

    private func setupView() {
        view.backgroundColor = .clear
    }

    private func setupContentView() {

        view.addSubview(contentView)

        let margin: CGFloat = 10.0

        let leadingAnchorConstraint = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin)
        leadingAnchorConstraint.priority = .defaultHigh

        let trailingAnchorConstraint  = view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: margin)
        trailingAnchorConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            leadingAnchorConstraint,
            trailingAnchorConstraint,
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentViewMaximumHeightLayoutConstraint,
            contentViewMaximumWidthLayoutConstraint,
            contentViewMinimumHeightLayoutConstraint
        ])
    }

    private func setupTitleLabel() {

        contentView.addSubview(titleLabel)

        let margin: CGFloat = 10.0
        let titleLabelHeight: CGFloat = 44.0

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin * 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin * 2),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight)
        ])
    }

    private func setupScrollView() {

        contentView.addSubview(scrollView)

        scrollViewHeightLayoutConstraint.priority = UILayoutPriority.defaultLow

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -24),
            scrollViewHeightLayoutConstraint
        ])
    }

    private func setupStackView() {

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupCloseButton() {

        contentView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupGestureRecognizer() {
        let closeOnTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeButtonAction))
        closeOnTapGestureRecognizer.delegate = self
        view.addGestureRecognizer(closeOnTapGestureRecognizer)

        let dragContentViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragContentViewGesture))
        dragContentViewGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(dragContentViewGestureRecognizer)
    }

    //    MARK: - Initialization

    public init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupContentView()
        setupTitleLabel()
        setupCloseButton()
        setupScrollView()
        setupStackView()
        setupGestureRecognizer()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupContentView()
        setupTitleLabel()
        setupCloseButton()
        setupScrollView()
        setupStackView()
        setupGestureRecognizer()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateScrollViewHeightConstraint()
        flashScrollViewScrollIndicatorsIfNeeded()
    }
}

extension DJSemiModalViewController {

    //    MARK: - Private

    @IBAction private func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    public func updateScrollViewHeightConstraint() {
        let size = stackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        scrollViewHeightLayoutConstraint.constant = automaticallyAdjustsContentHeight ? size.height : stackView.frame.height
        scrollViewHeightLayoutConstraint.isActive = scrollViewHeightLayoutConstraint.constant > 0.0


        contentView.setNeedsUpdateConstraints()
        contentView.layoutIfNeeded()

        view.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func flashScrollViewScrollIndicatorsIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            if self.scrollView.bounds.height < self.scrollView.contentSize.height {
                self.scrollView.flashScrollIndicators()
            }
        }
    }
}

extension DJSemiModalViewController {

    //    MARK: Public

    /**
     * Set the title and title label text
     */
    override open var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    /**
     * Add a subview to the bottom of the content view
     */
    public func addArrangedSubview(view: UIView) {
        stackView.addArrangedSubview(view)
    }

    /**
     * Add a subview with a specified height to the bottom of the content view
     */
    public func addArrangedSubview(view: UIView, height: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height)
        ])

        addArrangedSubview(view: view)
    }

    /**
     * Insert a subview at an index of the content view
     */
    public func insertArrangedSubview(view: UIView, at index: Int) {
        stackView.insertArrangedSubview(view, at: index)
    }

    /**
     * Dismiss DJSemiModalViewController
     */

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        viewWillDismissHandler?()
        dismiss(animated: flag)
    }
}

extension DJSemiModalViewController {

    // MARK: Public presentation

    /**
     * Present the view on top of a controller, with animation and a dismiss closure
     */

    public func presentOn(presentingViewController: UIViewController, animated: Bool = true, onDismiss dismissHandler: ViewWillDismiss?) {

        modalPresentationStyle = .overCurrentContext

        self.viewWillDismissHandler = { [weak self] in

            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self?.backgroundCoverView.backgroundColor = UIColor.clear
            }, completion: { (_) in
                self?.backgroundCoverView.removeFromSuperview()
            })

            dismissHandler?()
        }

        presentingViewController.view.addSubview(backgroundCoverView)

        NSLayoutConstraint.activate([
            backgroundCoverView.leadingAnchor.constraint(equalTo: presentingViewController.view.leadingAnchor, constant: 0),
            backgroundCoverView.trailingAnchor.constraint(equalTo: presentingViewController.view.trailingAnchor, constant: 0),
            backgroundCoverView.bottomAnchor.constraint(equalTo: presentingViewController.view.bottomAnchor, constant: 0),
            backgroundCoverView.topAnchor.constraint(equalTo: presentingViewController.view.topAnchor, constant: 0)
            ])

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundCoverView.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        }, completion: { (_) in })

        presentingViewController.present(self, animated: true)
    }
}

//  MARK: -

extension DJSemiModalViewController: UIGestureRecognizerDelegate {

    //  MARK: UIGestureRecognizerDelegate

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            if let view = touch.view, view == self.view {
                return true
            }
            return false
        }
        return true
    }
}

extension DJSemiModalViewController {

    //  MARK: Gesture Handling

    @objc
    private func dragContentViewGesture(_ gestureRecognizer: UIPanGestureRecognizer) {

        if contentViewOriginalCenter == nil {
            contentViewOriginalCenter = contentView.center
        }

        moveContentView(gestureRecognizer: gestureRecognizer)

        contentViewStateEnded(gestureRecognizer: gestureRecognizer)
    }

    private func moveContentView(gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)

            guard let gestureRecognizerView = gestureRecognizer.view else {
                return
            }

            let newCenter = CGPoint(x: gestureRecognizerView.center.x,
                                    y: gestureRecognizerView.center.y + translation.y)
            gestureRecognizerView.center = newCenter

            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    private func contentViewStateEnded(gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == .ended, let contentViewOriginalCenter = self.contentViewOriginalCenter {

            let distance = contentViewOriginalCenter.y - self.contentView.center.y
            let velocity = gestureRecognizer.velocity(in: view)

            if velocity.y > 2_000 {
                dismiss(animated: true)
            } else {
                let springVelocity = -1.0 * velocity.y / distance

                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: springVelocity, options: .curveLinear, animations: {
                    self.contentView.center = contentViewOriginalCenter
                }, completion: { _ in })
            }
        }
    }
}

extension DJSemiModalViewController {

    //  MARK: View Transition

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        contentViewMaximumHeightLayoutConstraint.constant = size.height - 20

        if contentViewMinimumHeightLayoutConstraint.constant > contentViewMaximumHeightLayoutConstraint.constant {
            contentViewMinimumHeightLayoutConstraint.constant = contentViewMaximumHeightLayoutConstraint.constant
        } else {
            contentViewMinimumHeightLayoutConstraint.constant = minHeight
        }
    }
}
