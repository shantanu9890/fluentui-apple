//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

// MARK: DateTimePickerControllerMode

enum DateTimePickerControllerMode {
    case single, start, end
}

// MARK: - DateTimePickerController

/// A view controller that allows a user to select either a date or a combination of date and time using a custom control similar in appearance to UIDatePicker.
/// Has support for a start and end time/date.
class DateTimePickerController: UIViewController, GenericDateTimePicker {
    private struct Constants {
        static let idealRowCount: Int = 7
        static let idealWidth: CGFloat = 320
        static let titleButtonWidth: CGFloat = 160
        static let verticalPaddingFromSegmentControl: CGFloat = 4.0
    }

    var startDate: Date {
        didSet {
            startDate = startDate.rounded(toNearestMinutes: DateTimePickerViewDataSourceConstants.minuteInterval) ?? startDate
            switch mode {
            case .single:
                dateTimePickerView.setDate(startDate, animated: false)
                endDate = startDate
            case .start:
                dateTimePickerView.setDate(startDate, animated: false)
            case .end:
                break
            }
            updateNavigationBar()
        }
    }
    var endDate: Date {
        didSet {
            if mode != .single {
                endDate = endDate.rounded(toNearestMinutes: DateTimePickerViewDataSourceConstants.minuteInterval) ?? endDate
            }
            switch mode {
            case .single:
                endDate = startDate
            case .start:
                break
            case .end:
                dateTimePickerView.setDate(endDate, animated: false)
                updateNavigationBar()
            }

        }
    }
    private let leftBarButtonItem: UIBarButtonItem?
    private let rightBarButtonItem: UIBarButtonItem?

    private(set) var mode: DateTimePickerControllerMode {
        didSet {
            switch mode {
            case .start:
                dateTimePickerView.setDate(startDate, animated: false)
            case .end:
                dateTimePickerView.setDate(endDate, animated: false)
            case .single:
                dateTimePickerView.setDate(startDate, animated: false)
                endDate = startDate
            }
            updateNavigationBar()
        }
    }

    weak var delegate: GenericDateTimePickerDelegate?

    private let customTitle: String?
    private let customSubtitle: String?
    private let customStartTabTitle: String?
    private let customEndTabTitle: String?
    private let dateTimePickerView: DateTimePickerView
    private let titleView = TwoLineTitleView()
    private var segmentedControl: SegmentedControl?

    // TODO: Add availability back in? - contactAvailabilitySummaryDataSource: ContactAvailabilitySummaryDataSource?,
    init(startDate: Date, endDate: Date, calendarConfiguration: CalendarConfiguration, mode: DateTimePickerMode, titles: DateTimePicker.Titles?, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?) {
        self.mode = mode.singleSelection ? .single : .start
        self.startDate = startDate.rounded(toNearestMinutes: DateTimePickerViewDataSourceConstants.minuteInterval) ?? startDate
        self.endDate = self.mode == .single ? self.startDate : (endDate.rounded(toNearestMinutes: DateTimePickerViewDataSourceConstants.minuteInterval) ?? endDate)

        let datePickerMode: DateTimePickerViewMode = mode.includesTime ? .dateTime : .date
        dateTimePickerView = DateTimePickerView(mode: datePickerMode, calendarConfiguration: calendarConfiguration)
        dateTimePickerView.setDate(self.startDate, animated: false)

        customTitle = titles?.dateTimeTitle
        customSubtitle = titles?.dateTimeSubtitle
        customStartTabTitle = titles?.startTab
        customEndTabTitle = titles?.endTab
        self.leftBarButtonItem = leftBarButtonItem
        self.rightBarButtonItem = rightBarButtonItem

        super.init(nibName: nil, bundle: nil)

        dateTimePickerView.addTarget(self, action: #selector(handleDidSelectDate(_:)), for: .valueChanged)

        if self.mode != .single {
            initSegmentedControl(includesTime: mode.includesTime)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard FluentTheme.isApplicableThemeChange(notification, for: view) else {
            return
        }
        updateBackgroundColor()
        updateBarButtonColors()
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let segmentedControl = segmentedControl {
            view.addSubview(segmentedControl)
            // Hide default bottom border of navigation bar
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        updateBackgroundColor()
        view.addSubview(dateTimePickerView)
        dateTimePickerView.setupComponents(for: self)
        initNavigationBar()

        updateNavigationBar()
    }

    private func updateBackgroundColor() {
        view.backgroundColor = UIColor(light: view.fluentTheme.color(.background2).light,
                                       dark: view.fluentTheme.color(.background2).dark)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var verticalOffset: CGFloat = 0
        if let segmentedControl = segmentedControl {
            segmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: segmentedControl.intrinsicContentSize.height)
            verticalOffset = segmentedControl.frame.height + Constants.verticalPaddingFromSegmentControl
        }

        dateTimePickerView.frame = CGRect(x: 0, y: verticalOffset, width: view.frame.width, height: view.frame.height - verticalOffset)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBarButtonColors()
    }

    private func updateBarButtonColors() {
        navigationItem.rightBarButtonItem?.tintColor = view.fluentTheme.color(.brandForeground1)
        navigationItem.leftBarButtonItem?.tintColor = view.fluentTheme.color(.foreground2)
    }

    override func accessibilityPerformEscape() -> Bool {
        dismiss()
        return true
    }

    private func initSegmentedControl(includesTime: Bool) {
        let items: [SegmentItem]
        if includesTime {
            items = [SegmentItem(title: customStartTabTitle ?? "MSDateTimePicker.StartTime".localized),
                     SegmentItem(title: customEndTabTitle ?? "MSDateTimePicker.EndTime".localized)]
        } else {
            items = [SegmentItem(title: customStartTabTitle ?? "MSDateTimePicker.StartDate".localized),
                     SegmentItem(title: customEndTabTitle ?? "MSDateTimePicker.EndDate".localized)]
        }
        let segmentedControl = SegmentedControl(items: items, style: traitCollection.userInterfaceStyle == .dark ? .brandOverNavBarPill : .neutralOverNavBarPill)
        segmentedControl.onSelectAction = { [weak self] (_, index) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.handleDidSelectStartEnd(index)
        }
        self.segmentedControl = segmentedControl
    }

    private func initNavigationBar() {
        if let leftBarButtonItem = leftBarButtonItem {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        if let rightBarButtonItem = rightBarButtonItem {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = BarButtonItems.confirm(target: self, action: #selector(handleDidTapDone))
        }
        navigationItem.titleView = titleView
    }

    private func updateNavigationBar() {
        let titleDate = mode == .end ? endDate : startDate
        let title = customTitle ?? String.dateString(from: titleDate, compactness: .shortDaynameShortMonthnameDay)
        titleView.setup(title: title, subtitle: customSubtitle)
        updateTitleFrame()
    }

    private func updateTitleFrame() {
        if let navigationController = navigationController {
            titleView.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: Constants.titleButtonWidth,
                height: navigationController.navigationBar.frame.height
            )
        }
    }

    @objc private func handleDidSelectDate(_ datePicker: DateTimePickerView) {
        switch mode {
        case .single:
            startDate = datePicker.date
        case .start:
            let duration = endDate.timeIntervalSince(startDate)
            endDate = datePicker.date.addingTimeInterval(duration)
            startDate = datePicker.date
        case .end:
            endDate = datePicker.date
            if endDate < startDate {
                startDate = endDate
            }
        }
        delegate?.dateTimePicker(self, didSelectStartDate: startDate, endDate: endDate)
    }

    @objc private func handleDidSelectStartEnd(_ selectedIndex: Int) {
        mode = selectedIndex == 0 ? .start : .end
    }

    @objc private func handleDidTapDone(_ item: UIBarButtonItem) {
        dismiss()
    }

}

// MARK: - DateTimePickerController: CardPresentable

extension DateTimePickerController: CardPresentable {
    func idealSize() -> CGSize {
        var extraHeight: CGFloat = 0
        if let segmentedControlHeight = segmentedControl?.frame.height {
            extraHeight = segmentedControlHeight + Constants.verticalPaddingFromSegmentControl
        }
        return CGSize(
            width: Constants.idealWidth,
            height: DateTimePickerViewLayout.height(forRowCount: Constants.idealRowCount) + extraHeight
        )
    }
}
