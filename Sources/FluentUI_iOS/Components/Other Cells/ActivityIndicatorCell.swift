//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

// MARK: ActivityIndicatorCell

@objc(MSFActivityIndicatorCell)
open class ActivityIndicatorCell: UITableViewCell, TokenizedControl {
    public static let identifier: String = "ActivityIndicatorCell"

    @objc public var backgroundStyleType: TableViewCellBackgroundStyleType = .plain {
        didSet {
            if backgroundStyleType != oldValue {
                setupBackgroundColors()
                setNeedsUpdateConfiguration()
            }
        }
    }

    public typealias TokenSetKeyType = TableViewCellTokenSet.Tokens
    public let tokenSet: TableViewCellTokenSet = .init(customViewSize: { .default })

    private func updateAppearance() {
        setupBackgroundColors()
    }

    private let activityIndicator: MSFActivityIndicator = {
        let activityIndicator = MSFActivityIndicator(size: .small)
        activityIndicator.state.isAnimating = true
        return activityIndicator
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(activityIndicator)

        setupBackgroundColors()

        // Update appearance whenever `tokenSet` changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateAppearance()
        }
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let activityIndicatorView = activityIndicator
        activityIndicatorView.sizeToFit()
        activityIndicatorView.center = CGPoint(x: ceil(contentView.frame.width / 2), y: ceil(contentView.frame.height / 2))
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateAppearance()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        updateAppearance()
        activityIndicator.state.isAnimating = true
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity
        return CGSize(width: maxWidth, height: TableViewCellTokenSet.oneLineMinHeight)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private func setupBackgroundColors() {
        if backgroundStyleType != .custom {
            var customBackgroundConfig = UIBackgroundConfiguration.clear()
            customBackgroundConfig.backgroundColor = backgroundStyleType.defaultColor(tokenSet: tokenSet)
            backgroundConfiguration = customBackgroundConfig
        }
    }
}
