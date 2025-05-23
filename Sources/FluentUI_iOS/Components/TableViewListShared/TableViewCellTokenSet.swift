//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

public enum TableViewCellToken: Int, TokenSetKey {
    /// The background color of the TableView.
    case backgroundColor

    /// The grouped background color of the TableView.
    case backgroundGroupedColor

    /// The background color of the TableViewCell.
    case cellBackgroundColor

    /// The grouped background color of the TableViewCell.
    case cellBackgroundGroupedColor

    /// The selected background color of the TableViewCell.
    case cellBackgroundSelectedColor

    /// The leading image color.
    case imageColor

    /// The size dimensions of the customView.
    case customViewDimensions

    /// The trailing margin of the customView.
    case customViewTrailingMargin

    /// The title label color.
    case titleColor

    /// The subtitle label color.
    case subtitleColor

    /// The footer label color.
    case footerColor

    /// The color of the selectionImageView when it is selected.
    case selectionIndicatorOnColor

    /// The color of the selectionImageView when it is not selected.
    case selectionIndicatorOffColor

    /// The font for the title.
    case titleFont

    /// The font for the subtitle when the TableViewCell has two lines.
    case subtitleTwoLinesFont

    /// The font for the subtitle when the TableViewCell has three lines.
    case subtitleThreeLinesFont

    /// The font for the footer.
    case footerFont

    /// The color for the accessoryDisclosureIndicator.
    case accessoryDisclosureIndicatorColor

    /// The color for the accessoryDetailButton.
    case accessoryDetailButtonColor

    /// The color for the accessoryCheckmark.
    case accessoryCheckmarkColor

    /// The color of the separator.
    case separatorColor

    /// The main brand text color.
    case brandTextColor

    /// The brand background color for the boolean cell.
    case booleanCellBrandColor

    /// The danger text color in an ActionsCell.
    case dangerTextColor

    /// The communication text color in an ActionsCell.
    case communicationTextColor
}

public class TableViewCellTokenSet: ControlTokenSet<TableViewCellToken> {
    init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        self.customViewSize = customViewSize
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background1) }

            case .backgroundGroupedColor:
                return .uiColor { theme.color(.backgroundCanvas) }

            case .cellBackgroundColor:
                return .uiColor { theme.color(.background1) }

            case .cellBackgroundGroupedColor:
                return .uiColor { theme.color(.background3) }

            case .cellBackgroundSelectedColor:
                return .uiColor { theme.color(.background1Pressed) }

            case .imageColor:
                return .uiColor { theme.color(.foreground3) }

            case .customViewDimensions:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return 0.0
                    case .small:
                        return GlobalTokens.icon(.size240)
                    case .medium, .default:
                        return GlobalTokens.icon(.size400)
                    }
                }

            case .customViewTrailingMargin:
                return .float {
                    switch customViewSize() {
                    case .zero:
                        return GlobalTokens.spacing(.sizeNone)
                    case .small:
                        return GlobalTokens.spacing(.size160)
                    case .medium, .default:
                        return GlobalTokens.spacing(.size120)
                    }
                }

            case .titleColor:
                return .uiColor { theme.color(.foreground1) }

            case .subtitleColor:
                return .uiColor { theme.color(.foreground2) }

            case .footerColor:
                return .uiColor { theme.color(.foreground2) }

            case .selectionIndicatorOnColor:
                return .uiColor { theme.color(.brandForeground1) }

            case .selectionIndicatorOffColor:
                return .uiColor { theme.color(.foreground3) }

            case .titleFont:
                return .uiFont { theme.typography(.body1) }

            case .subtitleTwoLinesFont:
                return .uiFont { theme.typography(.caption1) }

            case .subtitleThreeLinesFont:
                return .uiFont { theme.typography(.body2) }

            case .footerFont:
                return .uiFont { theme.typography(.caption1) }

            case .accessoryDisclosureIndicatorColor:
                return .uiColor { theme.color(.foreground3) }

            case .accessoryDetailButtonColor:
                return .uiColor { theme.color(.foreground3) }

            case .accessoryCheckmarkColor:
                return .uiColor { Compatibility.isDeviceIdiomVision() ? .white : theme.color(.brandForeground1) }

            case .separatorColor:
                return .uiColor { theme.color(.stroke2) }

            case .dangerTextColor:
                return .uiColor { theme.color(.dangerForeground2) }

            case .brandTextColor:
                return .uiColor { theme.color(.brandForeground1) }

            case .booleanCellBrandColor:
                return .uiColor { theme.color(.brandBackground1) }

            case .communicationTextColor:
                return .uiColor {
                    UIColor(light: GlobalTokens.brandColor(.comm80),
                            dark: GlobalTokens.brandColor(.comm100))
                }
            }
        }
    }

    /// Defines the size of the customView size.
    var customViewSize: () -> MSFTableViewCellCustomViewSize
}

// MARK: Constants

extension TableViewCellTokenSet {
    /// The minimum TableViewCell height; the height of a TableViewCell with one line of text.
    static let oneLineMinHeight: CGFloat = Compatibility.isDeviceIdiomVision() ? 60.0 : GlobalTokens.spacing(.size480)

    /// The height of a TableViewCell with two lines of text.
    static let twoLineMinHeight: CGFloat = 64.0

    /// The height of a TableViewCell with three lines of text.
    static let threeLineMinHeight: CGFloat = 84.0

    /// The default horizontal spacing in the cell.
    static let horizontalSpacing: CGFloat = GlobalTokens.spacing(.size160)

    /// The leading padding in the cell.
    static let paddingLeading: CGFloat = GlobalTokens.spacing(.size160)

    /// The vertical padding in the cell.
    static let paddingVertical: CGFloat = 11.0

    /// The trailing padding in the cell.
    static let paddingTrailing: CGFloat = GlobalTokens.spacing(.size160)

    /// The leading and trailing padding for the unreadDotLayer.
    static let unreadDotHorizontalPadding: CGFloat = GlobalTokens.spacing(.size40)

    /// The size dimensions of the unreadDotLayer.
    static let unreadDotDimensions: CGFloat = 8.0

    static let selectionImageOff = UIImage.staticImageNamed("selection-off")
    static let selectionImageOn = UIImage.staticImageNamed("selection-on")

    /// The minimum height for the title label.
    static let titleHeight: CGFloat = 22.0

    /// The minimum height for the subtitle label when the TableViewCell has two lines.
    static let subtitleTwoLineHeight: CGFloat = 18.0

    /// The minimum height for the subtitle label when the TableViewCell has three lines.
    static let subtitleThreeLineHeight: CGFloat = 20.0

    /// The minimum height for the footer label.
    static let footerHeight: CGFloat = 18.0

    /// The leading margin for the labelAccessoryView.
    static let labelAccessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.size80)

    /// The trailing margin for the labelAccessoryView of the title label.
    static let titleLabelAccessoryViewMarginTrailing: CGFloat = GlobalTokens.spacing(.size80)

    /// The trailing margin for the labelAccessoryView of the subtitle label.
    static let subtitleLabelAccessoryViewMarginTrailing: CGFloat = GlobalTokens.spacing(.size40)

    /// The leading margin for the customAccessoryView.
    static let customAccessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.size80)

    /// The minimum vertical margin for the customAccessoryView.
    static let customAccessoryViewMinVerticalMargin: CGFloat = 6.0

    /// The vertical margin for the label when it has one or three lines.
    static let defaultLabelVerticalMarginForOneAndThreeLines: CGFloat = Compatibility.isDeviceIdiomVision() ? 19.0 : 11.0

    /// The vertical margin for the label when it has two lines.
    static let labelVerticalMarginForTwoLines: CGFloat = Compatibility.isDeviceIdiomVision() ? GlobalTokens.spacing(.size200) : GlobalTokens.spacing(.size120)

    /// The vertical spacing for the label.
    static let labelVerticalSpacing: CGFloat = GlobalTokens.spacing(.sizeNone)

    /// The trailing margin for the selectionImage.
    static let selectionImageMarginTrailing: CGFloat = GlobalTokens.spacing(.size160)

    /// The size for the selectionImage.
    static let selectionImageSize: CGFloat = GlobalTokens.icon(.size240)

    /// The duration for the selectionModeAnimation.
    static let selectionModeAnimationDuration: CGFloat = 0.2

    /// The minimum width for any text area.
    static let textAreaMinWidth: CGFloat = 100.0

    /// The alpha value that enables the user's ability to interact with a cell.
    static let enabledAlpha: CGFloat = 1.0

    /// The alpha value that disables the user's ability to interact with a cell; dims cell's contents.
    static let disabledAlpha: CGFloat = 0.35
}

/// Pre-defined sizes of the customView size.
@objc public enum MSFTableViewCellCustomViewSize: Int, CaseIterable {
    case `default`
    case zero
    case small
    case medium
}

// MARK: TableViewCellAccessoryType

@objc(MSFTableViewCellAccessoryType)
public enum TableViewCellAccessoryType: Int {
    case none
    case disclosureIndicator
    case detailButton
    case checkmark

    private struct Constants {
        static let horizontalSpacing: CGFloat = 16
        static let height: CGFloat = 44
    }

    var icon: UIImage? {
        let icon: UIImage?
        switch self {
        case .none:
            icon = nil
        case .disclosureIndicator:
            icon = UIImage.staticImageNamed("iOS-chevron-right-20x20")
        case .detailButton:
            icon = UIImage.staticImageNamed("more-24x24")
        case .checkmark:
            icon = UIImage.staticImageNamed("checkmark-24x24")
        }
        return icon
    }

    func iconColor(tokenSet: TableViewCellTokenSet, fluentTheme: FluentTheme) -> UIColor? {
        switch self {
        case .none:
            return nil
        case .disclosureIndicator:
            return tokenSet[.accessoryDisclosureIndicatorColor].uiColor
        case .detailButton:
            return tokenSet[.accessoryDetailButtonColor].uiColor
        case .checkmark:
            return tokenSet[.accessoryCheckmarkColor].uiColor
        }
    }

    var size: CGSize {
        if self == .none {
            return .zero
        }
        // Horizontal spacing includes 16pt spacing from content to icon and 16pt spacing from icon to trailing edge of cell
        let horizontalSpacing: CGFloat = Constants.horizontalSpacing * 2
        let iconWidth: CGFloat = icon?.size.width ?? 0
        return CGSize(width: horizontalSpacing + iconWidth, height: Constants.height)
    }
}

// Different background color is used for `TableViewCell` by getting the appropriate tokens and integrate with the cell's `UIBackgroundConfiguration`
@objc(MSFTableViewCellBackgroundStyleType)
public enum TableViewCellBackgroundStyleType: Int {
    // use for flat list of cells
    case plain
    // use for grouped list of cells
    case grouped
    // clear background so that TableView's background can be shown
    case clear
    // in case clients want to override the background on their own without using token system
    case custom

    func defaultColor(tokenSet: TableViewCellTokenSet) -> UIColor? {
        switch self {
        case .plain:
            return tokenSet[.cellBackgroundColor].uiColor
        case .grouped:
            return tokenSet[.cellBackgroundGroupedColor].uiColor
        case .clear:
            return .clear
        case .custom:
            return nil
        }
    }
}
