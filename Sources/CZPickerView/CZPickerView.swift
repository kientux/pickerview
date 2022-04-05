//
//  CZPickerView.swift
//  Sapo
//
//  Created by Kien Nguyen on 04/06/2021.
//  Copyright © 2021 Sapo Technology JSC. All rights reserved.
//

import Foundation
import UIKit

public typealias CZDismissCompletionCallback = () -> Void

open class CZPickerView: UIView {
    
    // MARK: - Private properties
    
    private static let CZP_FOOTER_HEIGHT: CGFloat = 48.0
    private static let CZP_HEADER_HEIGHT: CGFloat = 52.0
    private static let CZP_SEARCH_HEIGHT: CGFloat = 64.0
    private static let CZP_ROW_HEIGHT: CGFloat = 54.0

    private static let CZP_MAX_ITEMS = 7

    private static let CELL_IDENTIFIER = "czpicker_view_identifier"
    
    private var backgroundDimmingView: UIView!
    private var containerView: UIView!
    private var containerShadowView: UIView!
    private var headerView: UIView!
    private var searchView: UIView?
    private var footerview: UIView!
    private var tableView: UITableView!
    
    private var emptyView: UIView?
    private var emptyLabel: UILabel?
    private var emptyImageView: UIImageView?
    
    private var selectedIndexPaths: [IndexPath] = []
    
    private var searchField: UITextField?
    private var cancelButton: UIButton?
    private var confirmButton: UIButton?
    
    private var loadingView: UIView?
    private var loadingLabel: UILabel?
    
    private var containerViewHeight: NSLayoutConstraint?
    
    private var loadingStartedTime: Date?
    
    // MARK: - Public properties

    public var headerTitle: String?
    public var searchPlaceHolder: String?
    public var initialSearchText: String?

    public var requiredSelect: Bool = false

    public var cancelButtonTitle: String?
    public var confirmButtonTitle: String?

    public var customHeaderView: UIView?

    public var defaultFont: UIFont = .systemFont(ofSize: 16)

    public weak var delegate: CZPickerViewDelegate?
    public weak var dataSource: CZPickerViewDataSource?

    /** whether to show footer (including confirm and cancel buttons), default NO */
    public var needFooterView: Bool = false

    /** whether to show cancel button when footer is shown, default YES */
    public var needCancelButton: Bool = false

    public var enableConfirmButton: Bool = false

    /** whether allow tap background to dismiss the picker, default YES */
    public var tapBackgroundToDismiss: Bool = true

    /** Alpha of black background dimming view. Default 0.7 */
    public var backgroundDimmingViewAlpha: CGFloat = 0.7
    
    /** Corner radius of container view. Default 16 */
    public var containerCornerRadius: CGFloat = 16

    /** whether allow selection of multiple items/rows, default NO, if this
     property is YES, then footerView will be shown */
    public var allowMultipleSelection: Bool = false

    public var hasSelectAllOption: Bool = false
    public var selectAllRowTitle: String?

    /** picker header background color */
    public var headerBackgroundColor: UIColor?

    /** picker header title font */
    public var headerTitleFont: UIFont?

    /** picker header title color */
    public var headerTitleColor: UIColor?

    /** picker cancel button background color */
    public var cancelButtonBackgroundColor: UIColor?

    /** picker cancel button normal state color */
    public var cancelButtonNormalColor: UIColor?

    /** picker cancel button highlighted state color */
    public var cancelButtonHighlightedColor: UIColor?

    /** picker confirm button background color */
    public var confirmButtonBackgroundColor: UIColor?

    /** picker confirm button normal state color */
    public var confirmButtonNormalColor: UIColor?

    /** picker confirm button highlighted state color */
    public var confirmButtonHighlightedColor: UIColor?

    /** tint color for tableview, also checkmark color */
    public var checkmarkColor: UIColor?

    /** picker's animation duration for showing and dismissing */
    public var animationDuration: TimeInterval = 1

    /** width of picker */
    public var pickerWidth: CGFloat = 270

    public var showSearchView: Bool = false

    public var isLoading: Bool = false {
        didSet {
            loadingView?.isHidden = !isLoading
            
            if isLoading {
                emptyView?.isHidden = true
                loadingStartedTime = Date()
            }
        }
    }
    public var loadingText: String?

    public var cellStyle: UITableViewCell.CellStyle = .default

    public var emptyDataSetEnabled: Bool = false
    public var emptyDataText: String?
    public var emptyAttributedDataText: NSAttributedString?
    public var emptyDataImage: UIImage?
    
    public var loadImageFromURL: ((URL, UIImageView?) -> Void)?
    
    // MARK: - Initializations
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("This init is not supported")
    }
    
    private func commonInit() {
        tapBackgroundToDismiss = true
        needFooterView = false
        needCancelButton = true
        allowMultipleSelection = false
        hasSelectAllOption = false
        selectAllRowTitle = ""
        animationDuration = 0.5
        emptyDataSetEnabled = false
        enableConfirmButton = true

        backgroundDimmingViewAlpha = 0.7
        showSearchView = false
        cellStyle = .value1
        
        showSearchView = false
        searchPlaceHolder = "Tìm kiếm"
        
        isLoading = false
        loadingText = "Đang tìm kiếm"

        headerTitleColor = .darkText
        headerBackgroundColor = .white
        
        cancelButtonNormalColor = .primary
        cancelButtonHighlightedColor = .gray
        cancelButtonBackgroundColor = .white
        
        confirmButtonNormalColor = .primary
        confirmButtonHighlightedColor = .gray
        confirmButtonBackgroundColor = .white
    }
    
    // MARK: - Private functions
    
    private func setupSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
        
        loadingView = buildLoadingView()
        backgroundDimmingView = buildBackgroundDimmingView()
        containerView = buildContainerView()
        tableView = buildTableView()
        headerView = buildHeaderView()
        searchView = buildSearchView()
        footerview = buildFooterView()
        containerShadowView = buildShadowView()
        
        if emptyDataSetEnabled {
            buildEmptyView()
        }

        buildConstraints()
        layoutIfNeeded()
    }
    
    private func buildConstraints() {
        // dimming view
        addSubview(backgroundDimmingView)
        backgroundDimmingView.autoPinEdgesToSuperviewEdges()

        // container view
        addSubview(containerView)
        containerView.autoCenterInSuperview()

        // container shadow view
        insertSubview(containerShadowView, belowSubview: containerView)
        containerShadowView.autoPinEdges(toEdgesOf: containerView)

        if pickerWidth > 0 {
            containerView.autoSetDimension(.width, toSize: pickerWidth)
        } else {
            containerView.autoMatch(.width, to: .height, of: self, withMultiplier: 0.8)
        }

        // header view
        containerView.addSubview(headerView)
        headerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        // footer view
        containerView.addSubview(footerview)
        footerview.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        footerview.autoSetDimension(.height, toSize: needFooterView ? CZPickerView.CZP_FOOTER_HEIGHT : 0)
        
        if let searchView = searchView {
            // search view
            containerView.addSubview(searchView)
            searchView.autoPinEdge(toSuperviewEdge: .leading)
            searchView.autoPinEdge(toSuperviewEdge: .trailing)
            
            searchView.autoSetDimension(.height, toSize: CZPickerView.CZP_SEARCH_HEIGHT)
            searchView.autoPinEdge(.top, to: .bottom, of: headerView)
        }

        // table view
        let contentView = UIView()
        contentView.clipsToBounds = true
        containerView.addSubview(contentView)
        contentView.autoPinEdge(toSuperviewEdge: .leading)
        contentView.autoPinEdge(toSuperviewEdge: .trailing)
        if let searchView = searchView {
            contentView.autoPinEdge(.top, to: .bottom, of: searchView)
        } else {
            contentView.autoPinEdge(.top, to: .bottom, of: headerView)
        }
        contentView.autoPinEdge(.bottom, to: .top, of: footerview)
        
        contentView.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        
        if let emptyView = emptyView {
            contentView.addSubview(emptyView)
            emptyView.autoCenterInSuperview()
            emptyView.autoPinEdge(toSuperviewEdge: .leading,
                                  withInset: 16,
                                  relation: .greaterThanOrEqual,
                                  priority: .init(999))
            emptyView.autoPinEdge(toSuperviewEdge: .trailing,
                                  withInset: 16,
                                  relation: .greaterThanOrEqual,
                                  priority: .init(999))
            emptyView.isHidden = true
        }
        
        contentView.addSubview(loadingView!)
        loadingView?.autoPinEdgesToSuperviewEdges()
        loadingView?.isHidden = !isLoading
        
        let headerViewSeparator = UIView()
        headerViewSeparator.backgroundColor = .tableSeparator
        containerView.addSubview(headerViewSeparator)
        headerViewSeparator.autoPinEdge(.top, to: .bottom, of: headerView)
        headerViewSeparator.autoPinEdge(toSuperviewEdge: .leading)
        headerViewSeparator.autoPinEdge(toSuperviewEdge: .trailing)
        headerViewSeparator.autoSetDimension(.height, toSize: 1.0)

        let height = calculateContainerViewHeight()
        containerViewHeight = containerView.autoSetDimension(.height, toSize:height)
    }
    
    private func buildContainerView() -> UIView {
        let view = SquircleRoundedView()
        view.layer.cornerRadius = containerCornerRadius
        view.clipsToBounds = true
        return view
    }

    private func buildShadowView() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .zero
        return view
    }

    private func buildTableView() -> UITableView {
        let tableView = CZTableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .tableSeparator
        tableView.separatorInset = .zero
        tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 54.0 : 48.0
        tableView.tableFooterView = UIView()
        tableView.register(PickerViewCell.nib(),
                           forCellReuseIdentifier: CZPickerView.CELL_IDENTIFIER)
        
        tableView.reloadEmptyStateCallback = { [unowned self] in
            self.emptyView?.isHidden = self.tableView(self.tableView, numberOfRowsInSection: 0) > 0
        }
        return tableView
    }
    
    private func buildLoadingView() -> UIView {
        let loadingView = UIView()
        loadingView.backgroundColor = .white
        
        let loadingLabel = UILabel()
        loadingLabel.font = .italicSystemFont(ofSize: 16)
        loadingLabel.textColor = .grayText
        loadingLabel.text = loadingText
        loadingLabel.textAlignment = .center
        
        loadingView.addSubview(loadingLabel)
        loadingLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        loadingLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        loadingLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)
        self.loadingLabel = loadingLabel
        
        let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        activityIndicatorView.color = .primary
        activityIndicatorView.startAnimating()
        loadingView.addSubview(activityIndicatorView)
        activityIndicatorView.autoAlignAxis(toSuperviewAxis: .vertical)
        activityIndicatorView.autoPinEdge(.bottom, to: .top, of: loadingLabel, withOffset: -16)
        return loadingView
    }
    
    private func calculateContainerViewHeight() -> CGFloat {
        guard let dataSource = dataSource, let window = UIApplication.shared.keyWindow else {
            return 0
        }
        
        let numberOfRowsFromDataSource = dataSource.numberOfRows(in: self) + (hasSelectAllOption ? 1 : 0)
        let numberOfRows = min(CGFloat(numberOfRowsFromDataSource), CGFloat(CZPickerView.CZP_MAX_ITEMS) + 0.25)
        
        let tableViewHeight = numberOfRows == 0 ? 200.0 : CZPickerView.CZP_ROW_HEIGHT * numberOfRows - 1 // minus separator
        let footerHeight = needFooterView ? CZPickerView.CZP_FOOTER_HEIGHT : 0

        customHeaderView?.setNeedsLayout()
        customHeaderView?.layoutIfNeeded()

        let height = tableViewHeight + footerHeight
            + (customHeaderView != nil ? customHeaderView!.frame.height : CZPickerView.CZP_HEADER_HEIGHT)
            + (showSearchView ? CZPickerView.CZP_SEARCH_HEIGHT : 0)
        return min(height, window.bounds.size.height * 0.75)
    }
    
    private func buildBackgroundDimmingView() -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0

        if tapBackgroundToDismiss {
            let tap = UITapGestureRecognizer(target:self, action: #selector(cancelButtonPressed(_:)));
            backgroundView.addGestureRecognizer(tap)
        }

        return backgroundView
    }
    
    private func buildFooterView() -> UIView {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal

        if !needFooterView {
            return stackView
        }

        let cancelButton = UIButton(type: .custom)
        self.cancelButton = cancelButton
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(cancelButtonNormalColor, for: .normal)
        cancelButton.setTitleColor(cancelButtonHighlightedColor, for: .highlighted)
        cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        cancelButton.backgroundColor = cancelButtonBackgroundColor
        cancelButton.setBackgroundColor(.buttonHighlight, for: .highlighted)
        cancelButton.layer.borderColor = UIColor.tableSeparator.cgColor
        cancelButton.layer.borderWidth = 1.0 / UIScreen.main.scale
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)

        let confirmButton = UIButton(type: .custom)
        self.confirmButton = confirmButton
        confirmButton.setTitle(confirmButtonTitle, for: .normal)
        confirmButton.setTitleColor(confirmButtonNormalColor, for: .normal)
        confirmButton.setTitleColor(confirmButtonHighlightedColor, for: .highlighted)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 17)
        confirmButton.backgroundColor = confirmButtonBackgroundColor
        confirmButton.setBackgroundColor(.buttonHighlight, for: .highlighted)
        confirmButton.layer.borderColor = UIColor.tableSeparator.cgColor
        confirmButton.layer.borderWidth = 1.0 / UIScreen.main.scale
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed(_:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        
        if needCancelButton {
            cancelButton.isHidden = false
            confirmButton.isHidden = false
        } else if enableConfirmButton {
            cancelButton.isHidden = true
            confirmButton.isHidden = false
        } else {
            cancelButton.isHidden = false
            confirmButton.isHidden = true
        }

        return stackView
    }
    
    private func buildHeaderView() -> UIView {
        if let customHeaderView = customHeaderView {
            return customHeaderView
        }
        
        let view = UIView()
        view.backgroundColor = headerBackgroundColor
        let headerFont = headerTitleFont ?? .systemFont(ofSize: 17)

        let label = UILabel()
        label.text = headerTitle
        label.textColor = headerTitleColor
        label.font = headerFont
        label.textAlignment = .center
        view.addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        view.autoSetDimension(.height, toSize: CZPickerView.CZP_HEADER_HEIGHT)

        return view
    }

    private func buildSearchView() -> UIView? {
        guard showSearchView else {
            return nil
        }
        
        let view = UIView()
        view.backgroundColor = .white
        
        let shadowView = RoundedShadowView()
        shadowView.backgroundColor = .white
        shadowView.shadowColor = UIColor(r: 77, g: 96, b: 168)
        shadowView.shadowOpacity = 0.2
        shadowView.shadowRadius = 4.0
        view.addSubview(shadowView)
        
        shadowView.autoPinEdgesToSuperviewEdges(with: .all(12))
        
        let searchField = UITextField()
        self.searchField = searchField
        let searchAttrString = NSMutableAttributedString(
            string: searchPlaceHolder ?? "Search",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: defaultFont
            ]
        )
        searchField.attributedPlaceholder = searchAttrString
        searchField.textColor = .text
        searchField.font = defaultFont
        searchField.autocorrectionType = .no
        searchField.clearButtonMode = .whileEditing
        searchField.text = initialSearchText
        
        searchField.addTarget(self,
                              action: #selector(searchTextFieldEditingChanged(_:)),
                              for: .editingChanged)
        // notify
        searchTextFieldEditingChanged(searchField)
        
        shadowView.addSubview(searchField)
        searchField.autoPinEdgesToSuperviewEdges(with: .right(10), excludingEdge: .leading)
        
        let searchIcon = UIImageView(image: UIImage(named: "ic_picker_view_search",
                                                    in: Bundle.module,
                                                    compatibleWith: nil))
        searchIcon.contentMode = .center
        shadowView.addSubview(searchIcon)
        searchIcon.autoPinEdgesToSuperviewEdges(with: .left(10), excludingEdge: .trailing)
        searchIcon.autoPinEdge(.trailing, to: .leading, of: searchField, withOffset: -8.0)
        searchIcon.autoSetDimension(.width, toSize: 24)
        
        return view
    }
    
    private func buildEmptyView() {
        let emptyView = UIStackView()
        emptyView.backgroundColor = .white
        emptyView.axis = .vertical
        emptyView.alignment = .fill
        emptyView.distribution = .equalSpacing
        emptyView.spacing = 8.0
        
        let emptyLabel = UILabel()
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.lineBreakMode = .byWordWrapping
        
        let emptyImageView = UIImageView()
        emptyImageView.contentMode = .center
        
        emptyView.addArrangedSubview(emptyLabel)
        emptyView.addArrangedSubview(emptyImageView)
        
        if let emptyAttributedDataText = emptyAttributedDataText {
            emptyLabel.attributedText = emptyAttributedDataText
        } else if let emptyDataText = emptyDataText {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.text
            ]
            emptyLabel.attributedText = NSAttributedString(string: emptyDataText, attributes: attributes)
        }
        
        emptyImageView.image = emptyDataImage
        
        self.emptyView = emptyView
        self.emptyLabel = emptyLabel
        self.emptyImageView = emptyImageView
    }
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        dismiss {
            self.delegate?.czpickerViewDidClickCancelButton(self)
        }
    }
    
    @objc private func confirmButtonPressed(_ sender: UIButton) {
        dismiss {
            if self.allowMultipleSelection {
                var selectedRows = self.selectedRows
                if self.hasSelectAllOption {
                    var newSelectedRows = [Int]()
                    for row in selectedRows {
                        newSelectedRows.append(row - 1)
                    }
                    selectedRows = newSelectedRows
                }
                self.delegate?.czpickerView(self, didConfirmWithItemsAtRows: selectedRows)
            } else if self.needFooterView {
                self.delegate?.czpickerViewDidClickConfirmButton(self)
            } else if !self.allowMultipleSelection {
                if self.selectedIndexPaths.count > 0 {
                    let row = self.selectedIndexPaths[0].row
                    self.delegate?.czpickerView(self, didConfirmWithItemAtRow: row)
                }
            }
        }
    }
    
    @objc private func searchTextFieldEditingChanged(_ textField: UITextField) {
        selectedIndexPaths.removeAll()
        delegate?.czpickerView(self, searching: textField.text ?? "")
        tableView.reloadData()
    }
    
    open override func layoutSubviews() {
        containerViewHeight?.constant = calculateContainerViewHeight()
        super.layoutSubviews()
    }
    
    // MARK: - Public functions
    
    /** show the picker */
    open func show() {
        if allowMultipleSelection && !needFooterView {
            needFooterView = true
        }

        guard let mainWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        self.frame = mainWindow.frame
        mainWindow.addSubview(self)
        autoPinEdgesToSuperviewEdges()
        setupSubviews()

        containerView.alpha = 0
        containerShadowView.alpha = 0

        let transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        containerView.transform = transform
        containerShadowView.transform = transform

        mainWindow.endEditing(true)

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: []) {
            self.containerView.transform = .identity
            self.containerShadowView.transform = .identity

            self.containerView.alpha = 1
            self.containerShadowView.alpha = 1

            if let backgroundDimmingView = self.backgroundDimmingView as? UIVisualEffectView {
                let effect = UIBlurEffect(style: .dark)
                backgroundDimmingView.effect = effect
            } else {
                self.backgroundDimmingView.alpha = self.backgroundDimmingViewAlpha
            }
        }
    }

    /** dismiss the picker */
    open func dismiss(completion: CZDismissCompletionCallback? = nil) {
        let transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(withDuration: 0.2) {
            self.containerView.alpha = 0
            self.containerShadowView.alpha = 0

            self.containerView.transform = transform
            self.containerShadowView.transform = transform

            if let backgroundDimmingView = self.backgroundDimmingView as? UIVisualEffectView {
                backgroundDimmingView.effect = nil
            } else {
                self.backgroundDimmingView.alpha = 0
            }
        } completion: { _ in
            completion?()
            
            for view in self.subviews {
                view.removeFromSuperview()
            }
            
            self.removeFromSuperview()
            self.delegate?.czpickerViewDidDismissWhenTappingOutSide()
        }
    }

    /** reload list content */
    open func reload() {
        if isLoading {
            return
        }
        
        if !needCancelButton && !enableConfirmButton {
            cancelButton?.isHidden = false
            confirmButton?.isHidden = true
        } else if needCancelButton {
            cancelButton?.isHidden = false
            confirmButton?.isHidden = false
        } else {
            cancelButton?.isHidden = true
            confirmButton?.isHidden = false
        }
        
        var shouldAnimateHeight = false
        let now = Date()
        if let loadingStartedTime = loadingStartedTime,
           now.timeIntervalSinceReferenceDate - loadingStartedTime.timeIntervalSinceReferenceDate > 0.3 {
            self.loadingStartedTime = nil
            shouldAnimateHeight = true
        }
        
        loadingView?.isHidden = true
        tableView?.reloadData()
        containerViewHeight?.constant = calculateContainerViewHeight()
        
        if shouldAnimateHeight {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.layoutIfNeeded()
                           })
        }
    }

    /** return previously selected row. */
    open var selectedRows: [Int] {
        if !hasSelectAllOption {
            return selectedIndexPaths.map({ $0.row })
        }
        
        return selectedIndexPaths.filter({ $0.row != 0 }).map({ $0.row })
    }

    /** set pre-selected rows. */
    open func setSelectedRows(_ rows: [Int]?) {
        let rows = rows ?? []
        selectedIndexPaths.removeAll()
        if hasSelectAllOption {
            if let dataSource = dataSource, rows.count == dataSource.numberOfRows(in: self) {
                selectedIndexPaths.append(IndexPath(row: 0, section: 0))
            }
            
            selectedIndexPaths.append(contentsOf: rows.map({ IndexPath(row: $0 + 1, section: 0) }))
        } else {
            selectedIndexPaths.append(contentsOf: rows.map({ IndexPath(row: $0, section: 0) }))
        }
    }

    open func hideConfirmButton() {
        needCancelButton = false
        enableConfirmButton = false
    }
    
    open func showConfirmButton() {
        needCancelButton = true
    }
}

// MARK: - UITableViewDataSource
extension CZPickerView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        
        return dataSource.numberOfRows(in: self) + (hasSelectAllOption ? 1 : 0)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CZPickerView.CELL_IDENTIFIER,
                                                 for: indexPath) as! PickerViewCell
        cell.label.font = self.defaultFont
        cell.detailLabel.font = self.defaultFont
        
        if hasSelectAllOption {
            if indexPath.row == 0 {
                cell.label.text = selectAllRowTitle
            } else {
                configCell(cell, at: indexPath.row - 1)
            }
        } else {
            configCell(cell, at: indexPath.row)
        }

        if let checkmarkColor = checkmarkColor {
            cell.tintColor = checkmarkColor
        }
        
        cell.accessoryType = .none
        
        for ip in selectedIndexPaths where ip.row == indexPath.row {
            cell.accessoryType = .checkmark
            break
        }
        
        return cell
    }

    private func configCell(_ cell: PickerViewCell, at row: Int) {
        guard let dataSource = dataSource else {
            return
        }
        
        if let title = dataSource.czpickerView(self, attributedTitleForRow: row) {
            cell.label.attributedText = title
            cell.label.isHidden = false
        } else if let title = dataSource.czpickerView(self, titleForRow: row) {
            cell.label.text = title
            cell.label.isHidden = false
        } else {
            cell.label.text = nil
            cell.label.isHidden = true
        }
        
        if let detailTitle = dataSource.czpickerView(self, attributedDetailTitleForRow: row) {
            cell.detailLabel.attributedText = detailTitle
            cell.detailLabel.isHidden = false
        } else if let detailTitle = dataSource.czpickerView(self, detailTitleForRow: row) {
            cell.detailLabel.text = detailTitle
            cell.detailLabel.isHidden = false
        } else {
            cell.detailLabel.text = nil
            cell.detailLabel.isHidden = true
        }
        
        if let image = dataSource.czpickerView(self, imageForRow: row) {
            cell.imgView.image = image
            cell.imgView.isHidden = false
        } else if let url = dataSource.czpickerView(self, imageURLForRow: row) {
            precondition(loadImageFromURL != nil, "loadImageFromURL must be set when dataSource has imageURLForRow")
            loadImageFromURL?(url, cell.imgView)
            cell.imgView.isHidden = false
        } else {
            cell.imgView.image = nil
            cell.imgView.isHidden = true
        }
    }
}

// MARK: - UITableViewDelegate
extension CZPickerView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CZPickerView.CZP_ROW_HEIGHT
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let dataSource = dataSource else {
            return
        }
        
        let numberOfRows = dataSource.numberOfRows(in: self) + 1
        
        if allowMultipleSelection {
            if hasSelectAllOption {
                if indexPath.row == 0 { //First row will always be Select All option
                    if selectedIndexPaths.contains(indexPath) {
                        selectedIndexPaths.removeAll()
                        for i in 0..<numberOfRows {
                            let ip = IndexPath(row: i, section: 0)
                            tableView.cellForRow(at: ip)?.accessoryType = .none
                        }
                    } else {
                        selectedIndexPaths.removeAll()
                        for i in 0..<numberOfRows {
                            let ip = IndexPath(row: i, section: 0)
                            tableView.cellForRow(at: ip)?.accessoryType = .checkmark
                            selectedIndexPaths.append(ip)
                        }
                    }
                } else {
                    let selectAllIp = IndexPath(row: 0, section: 0)
                    let selectAllCell = tableView.cellForRow(at: selectAllIp)
                    if selectedIndexPaths.contains(indexPath) {
                        //If all items are selected and we remove one item => remove Select all option
                        if selectedIndexPaths.count == numberOfRows {
                            selectedIndexPaths.removeAll(where: { $0 == selectAllIp })
                            selectAllCell?.accessoryType = .none
                        }
                        selectedIndexPaths.removeAll(where: { $0 == indexPath })
                        cell?.accessoryType = .none
                    } else {
                        //If the only unselected item is selected => Add Select All option
                        if selectedIndexPaths.count == numberOfRows - 2 {
                            selectedIndexPaths.append(selectAllIp)
                            selectAllCell?.accessoryType = .checkmark
                        }
                        selectedIndexPaths.append(indexPath)
                        cell?.accessoryType = .checkmark
                    }
                }
            } else {
                if selectedIndexPaths.contains(indexPath) {
                    selectedIndexPaths.removeAll(where: { $0 == indexPath })
                    cell?.accessoryType = .none
                } else {
                    selectedIndexPaths.append(indexPath)
                    cell?.accessoryType = .checkmark
                }
            }
        } else { // single selection mode
            
            //Dismiss picker if there is no footer view (confirm/cancel button), else add a checkmark icon to the selected row
            if !needFooterView {
                dismiss {
                    self.delegate?.czpickerView(self, didConfirmWithItemAtRow: indexPath.row)
                }
            } else {
                if !selectedIndexPaths.contains(indexPath) {
                    for i in 0..<numberOfRows {
                        let ip = IndexPath(row: i, section: 0)
                        tableView.cellForRow(at: ip)?.accessoryType = .none
                    }
                    selectedIndexPaths.removeAll()
                    selectedIndexPaths.append(indexPath)
                    cell?.accessoryType = .checkmark
                }
                
                self.delegate?.czpickerView(self, didSelectItemAtRow: indexPath.row)
            }
        }
    }
}
