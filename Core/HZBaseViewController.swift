//
//  HZBaseViewController.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/2/20.
//

import UIKit
import SnapKit

class HZBaseViewController: UIViewController {
    
    private(set) lazy var tableViewPlain: UITableView = {
        let _tableViewPlain = UITableView(frame: .zero, style: .plain)
        _tableViewPlain.separatorStyle = .none
        _tableViewPlain.backgroundColor = UIColor(red: 244.0/255.0, green: 246.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        if #available(iOS 11.0, *) {
            _tableViewPlain.estimatedRowHeight = 0
            _tableViewPlain.estimatedSectionHeaderHeight = 0
            _tableViewPlain.estimatedSectionFooterHeight = 0
            
            _tableViewPlain.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if #available(iOS 15.0, *) {
            _tableViewPlain.sectionHeaderTopPadding = 0
        }
        return _tableViewPlain
    }()
    fileprivate lazy var backItem: UIBarButtonItem = {
        let _backItem = UIBarButtonItem(image: UIImage(named: self.navigationController?.viewControllers.count == 1 ? "navigationBar_closeIcon_white" : "navigationBar_backIcon_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didBackItemAction(_:)))
        return _backItem
    }()
    //    private(set) var tableViewModel: HZTableViewModel = HZTableViewModel()
    internal var tableViewData: [(String, [Any], HZDebugTableViewCellType)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc fileprivate func didBackItemAction(_ sender: UIBarButtonItem) {
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.dismiss(animated: true)
            HZDebugTool.delegate?.debugToolClose()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableViewPlain.reloadData()
    }
    
    internal func setTableView() {
        self.tableViewPlain.delegate = self
        self.tableViewPlain.dataSource = self
        self.tableViewPlain.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0)
        view.addSubview(self.tableViewPlain)
        tableViewPlain.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    // 点击返回
    public func backToLastViewController() {
        self.didBackItemAction(backItem)
    }
    
    // 给子VC自定义修改的方法
    public func cellForRowAction(tableView: UITableView, cell: HZDebugTableViewCell, indexPath: IndexPath, cellType: HZDebugTableViewCellType, cellData: Any) {
    }
    
    // 子VC处理cell点击事件
    public func didSelectRowAction(tableView: UITableView, indexPath: IndexPath, cellType: HZDebugTableViewCellType, cellData: Any) {
    }
    
}
    
//    fileprivate func setUI() {
//        self.view.backgroundColor = .white
//        if let _count = self.navigationController?.viewControllers.count {
//            let backItem = UIBarButtonItem(image: UIImage(named: _count > 1 ? "navigationBar_backIcon_white" : "navigationBar_closeIcon_white"), style: .plain, target: self, action: #selector(leftBarItemClickAction))
//            self.navigationItem.leftBarButtonItem = backItem
//            self.navigationController?.navigationBar.backIndicatorImage
//        }
//        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18.0)]
//        if #available(iOS 13.0, *) {
//            let barAppearance = UINavigationBarAppearance()
//            barAppearance.backgroundColor = .white
//            barAppearance.titleTextAttributes = titleTextAttributes
//            barAppearance.shadowColor = .clear
//            self.navigationController?.navigationBar.standardAppearance = barAppearance
//            self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
//        }else {
//            self.navigationController?.navigationBar.barTintColor = .white
//            self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
////            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), barMetrics: UIBarMetrics.default)
//            self.navigationController?.navigationBar.shadowImage = UIImage()
//        }

//        self.tableViewPlain.delegate = tableViewModel
//        self.tableViewPlain.dataSource = tableViewModel
//        self.tableViewPlain.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0)
//        view.addSubview(self.tableViewPlain)
//        tableViewPlain.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalToSuperview().offset(64.0)
//        }
//        self.getTableViewModel()
//    }
    
//    public func getTableViewModel() {
//        self.tableViewModel.sectionModelArray?.removeAll()
//
//        self.tableViewData.enumerated().forEach { [weak self] (element) in
//            guard let sectionModel = self?.getTableViewSectionModel(element.offset, sectionData: element.element) else { return }
//            self?.tableViewModel.sectionModelArray?.append(sectionModel)
//        }
//        self.tableViewPlain.reloadData()
//    }
//
//    fileprivate func getTableViewSectionModel(_ section: Int, sectionData: (String, [Any])) -> HZTableViewSectionModel {
//        let sectionModel = HZTableViewSectionModel()
//        sectionModel.headerHeight = 35.0
//        sectionModel.viewForHeaderHandler = { (tableView, section) in
//            return HZDebugHeaderView(titleString: sectionData.0)
//        }
//        if section < self.tableViewData.count {
//            self.tableViewData[section].1.forEach { [weak self] cellData in
//                guard let cellModel = self?.getTableViewCellModel(cellData) else { return }
//                sectionModel.cellModelArray?.append(cellModel)
//            }
//        }
//        return sectionModel
//    }
//
//    fileprivate func getTableViewCellModel(_ cellData: Any) -> HZTableViewCellModel {
//        let cellModel = HZTableViewCellModel()
//        cellModel.height = 44.0
//        cellModel.cellForRowHandler = { [weak self] (tableView, indexPath) in
//
//            var cell = tableView.dequeueReusableCell(withIdentifier: "HZDebugTableViewCell")
//            if cell == nil {
//                cell = HZDebugTableViewCell(style: .default, reuseIdentifier: "HZDebugTableViewCell")
//            }
//            guard let _cell = cell as? HZDebugTableViewCell else {
//                return UITableViewCell()
//            }
//
//            if let _cellDataString = cellData as? String {
//                _cell.titleString = _cellDataString
//            }else if let _cellDataTuples = cellData as? (String, String) {
//                _cell.titleString = _cellDataTuples.0
//                _cell.subTitleString = _cellDataTuples.1
//            }
//            self?.cellForRowAction(tableView: tableView, cell: _cell, indexPath: indexPath, cellData: cellData)
//            return _cell
//        }
//        cellModel.didSelectRowHandler = { [weak self] (tableView, indexPath) in
//            self?.didSelectRowAction(tableView: tableView, indexPath: indexPath, cellData: cellData)
//        }
//        return cellModel
//    }
//
//    @objc public func leftBarItemClickAction() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    public func cellForRowAction(tableView: UITableView, cell: HZDebugTableViewCell, indexPath: IndexPath, cellData: Any) {
//    }
//
//    public func didSelectRowAction(tableView: UITableView, indexPath: IndexPath, cellData: Any) {
//    }
//
//}
//
//

extension HZBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData[section].1.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HZDebugHeaderView(titleString: self.tableViewData[section].0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HZDebugTableViewCell")
        if cell == nil {
            cell = HZDebugTableViewCell(style: .default, reuseIdentifier: "HZDebugTableViewCell")
        }
        guard let _cell = cell as? HZDebugTableViewCell else {
            return HZDebugTableViewCell()
        }
        let cellData = self.tableViewData[indexPath.section].1[indexPath.row]
        if let _cellDataString = cellData as? String {
            _cell.titleString = _cellDataString
            _cell.subTitleString = ""
        }else if let _cellDataTuples = cellData as? (String, String) {
            _cell.titleString = _cellDataTuples.0
            _cell.subTitleString = _cellDataTuples.1
        }
        self.cellForRowAction(tableView: tableView, cell: _cell, indexPath: indexPath, cellType: self.tableViewData[indexPath.section].2, cellData: cellData)
        return _cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRowAction(tableView: tableView, indexPath: indexPath, cellType: self.tableViewData[indexPath.section].2, cellData: self.tableViewData[indexPath.section].1[indexPath.row])
    }
    
}

//MARK: - HZDebugHeaderView
fileprivate class HZDebugHeaderView: UIView {

    private var titleString: String?

    init(titleString: String) {
        super.init(frame: .zero)
        self.titleString = titleString
        self.setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setUI() {
        self.backgroundColor = UIColor(red: 73.0/255.0, green: 79.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        let label = UILabel()
        label.text = self.titleString
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

//MARK: - HZDebugTableViewCell
internal class HZDebugTableViewCell: UITableViewCell {

    var titleString: String? {
        willSet {
            lblTitle.text = newValue
        }
    }

    var titleAttributedText: NSAttributedString? {
        willSet {
            lblTitle.attributedText = newValue
            lblSubTitle.text = ""
        }
    }

    var subTitleString: String? {
        willSet {
            lblSubTitle.text = newValue
        }
    }

    var isHiddenLine: Bool = false {
        willSet {
            lineView.isHidden = newValue
        }
    }

    lazy var lblTitle: UILabel = {
        let _lblTitle = UILabel()
        _lblTitle.textColor = UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        _lblTitle.font = UIFont.systemFont(ofSize: 15.0)
        _lblTitle.textAlignment = .left
        return _lblTitle
    }()

    lazy var lblSubTitle: UILabel = {
        let _lblSubTitle = UILabel()
        _lblSubTitle.textColor = UIColor(red: 67.0/255.0, green: 70.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        _lblSubTitle.font = UIFont.systemFont(ofSize: 15.0)
        _lblSubTitle.textAlignment = .right
        return _lblSubTitle
    }()

    private lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.backgroundColor = UIColor(red: 228.0/255.0, green: 229.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        return _lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15.0)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(lblSubTitle)
        lblSubTitle.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15.0)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10.0)
            make.right.equalToSuperview().offset(-10.0)
            make.height.equalTo(0.7)
        }
    }
    
}
