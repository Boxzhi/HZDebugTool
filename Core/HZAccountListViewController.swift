//
//  HZAccountListViewController.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/2.
//

import UIKit

class HZAccountListViewController: HZBaseViewController {
    
    fileprivate var loginAccounts: [String: [String: String]]? {
        if let _accounts = HZKeychainTool.getContentFromKeyChain(service: "HZDebugTool", account: "DebugToolAccounts"), let _accountsDic = _accounts.toDictionary() as? [String: [String: String]], HZDebugTool.default.isAlwaysDelegateAccount == false {
            return _accountsDic
        }else if let _loginAccounts = HZDebugTool.delegate?.debugToolOfLoginAccounts() {
            if let _loginAccountString = _loginAccounts.toJsonString(), HZDebugTool.default.isAlwaysDelegateAccount == false {
                let _ = HZKeychainTool.saveContentFromKeyChain(content: _loginAccountString, service: "HZDebugTool", account: "DebugToolAccounts")
            }
            return _loginAccounts
        }else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择登录账号"
        reloadData()
        setTableView()
    }
    
    fileprivate func reloadData() {
        var dataSource: [(String, [Any], HZDebugTableViewCellType)] = [("手动输入账号密码", ["输入账号密码"], .manualInput)]
        let environments = HZDebugTool.delegate?.debugToolOfRequestEnvironments()
        if let _environments = environments {
            _environments.enumerated().forEach { element in
                loginAccounts?.keys.forEach({ key in
                    if key.contains(element.element) {
                        if let _accounts = loginAccounts?[key]?.compactMap({ $0.key }) {
                            dataSource += [(key, _accounts, .accountList)]
                        }
                    }
                })
            }
        }

        self.tableViewData = dataSource
        self.tableViewPlain.reloadData()
    }
    
    override func cellForRowAction(tableView: UITableView, cell: HZDebugTableViewCell, indexPath: IndexPath, cellType: HZDebugTableViewCellType, cellData: Any) {
        if cellType == .manualInput {
            cell.titleAttributedText = NSAttributedString(string: "输入账号密码", attributes: [.foregroundColor: UIColor(red: 252.0/255.0, green: 31.0/255.0, blue: 57.0/255.0, alpha: 1.0)])
        }else if let _currentEnvironment = HZDebugTool.delegate?.debugToolOfCurrentEnvironment(), self.tableViewData[indexPath.section].0.contains(_currentEnvironment) == true, let _currentLoginAccount = HZDebugTool.delegate?.debugToolOfCurrentLoginAccount(), let _cellData = cellData as? String, _currentLoginAccount == _cellData {
                let attributedText = NSMutableAttributedString(string: _cellData, attributes: [.foregroundColor: UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)])
                attributedText.append(NSAttributedString(string: "（当前已登账号）", attributes: [.foregroundColor: UIColor(red: 252.0/255.0, green: 31.0/255.0, blue: 57.0/255.0, alpha: 1.0)]))
                cell.titleAttributedText = attributedText
        }else if let _cellData = cellData as? String {
            cell.titleAttributedText = NSAttributedString(string: _cellData, attributes: [.foregroundColor: UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)])
        }
    }
    
    override func didSelectRowAction(tableView: UITableView, indexPath: IndexPath, cellType: HZDebugTableViewCellType, cellData: Any) {
        if cellType == .manualInput {
            HZDebugAccountAlertView.showAccountAlertView { account, password, environment in
                if let _account = account, let _password = password {
                    HZDebugTool.delegate?.debugToolSelectAccount(environment, account: _account, password: _password, loginSuccessHandler: {
                        HZAccountListViewController.addOrDeleteAccount(environment, account: _account, password: _password)
                        self.reloadData()
                    })
                }
            }
        }else if cellType == .accountList, let _account = cellData as? String {
            if let _loginAccounts = loginAccounts?[self.tableViewData[indexPath.section].0], let _password = _loginAccounts[_account] {
                HZDebugTool.delegate?.debugToolSelectAccount(self.tableViewData[indexPath.section].0, account: _account, password: _password, loginSuccessHandler: {
                    HZAccountListViewController.addOrDeleteAccount(self.tableViewData[indexPath.section].0, account: _account, password: _password)
                    self.reloadData()
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let type = self.tableViewData[indexPath.section].0
            if let _account = self.tableViewData[indexPath.section].1[indexPath.row] as? String, let _accounts = loginAccounts?[type], let _password = _accounts[_account] {
                HZAccountListViewController.addOrDeleteAccount(type, account: _account, password: _password, isAdd: false)
                self.reloadData()
            }
        }
    }
    
    static func addOrDeleteAccount(_ environment: String, account: String, password: String, isAdd: Bool = true) {
        var typeTemp: [String: [String: String]] = [:]
        if let _debugAccounts = HZKeychainTool.getContentFromKeyChain(service: "HZDebugTool", account: "DebugToolAccounts")?.toDictionary() as? [String: [String: String]] {
            _debugAccounts.forEach { typeKeyValue in
                if typeKeyValue.key.contains(environment) {
                    var apTemp = typeKeyValue.value
                    apTemp.removeValue(forKey: account)
                    if isAdd {
                        apTemp[account] = password
                    }
                    typeTemp[typeKeyValue.key] = apTemp
                }else {
                    typeTemp[typeKeyValue.key] = typeKeyValue.value
                }
            }
        }else if isAdd, let _environments = HZDebugTool.delegate?.debugToolOfRequestEnvironments() {
            _environments.forEach { _environment in
                if environment.contains(_environment) {
                    let key = environment.contains("账号") ? environment : "\(environment)账号"
                    typeTemp[key] = [account: password]
                }
            }
        }
        if let _string = typeTemp.toJsonString() {
            let _ = HZKeychainTool.saveContentFromKeyChain(content: _string, service: "HZDebugTool", account: "DebugToolAccounts")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

}

//MARK: - HZDebugAccountAlertView
fileprivate class HZDebugAccountAlertView: UIView {
    
    class func showAccountAlertView(_ clickConfirmHandler: @escaping (String?, String?, String) -> Void) {
        UIApplication.shared.keyWindow?.addSubview(HZDebugAccountAlertView(HZDebugTool.delegate?.debugToolOfRequestEnvironments(), clickConfirmHandler: clickConfirmHandler))
    }
    
    var environments: [String]?
    var selectedEnvironment: String = ""
    var selectButton: UIButton?
    var clickConfirmHandler: ((String?, String?, String) -> Void)?
    
    private lazy var contentView: UIView = {
        let _contentView = UIView()
        _contentView.backgroundColor = .white
        return _contentView
    }()
    
    private lazy var accountTF: UITextField = {
        let _accountTF = UITextField()
        _accountTF.placeholder = "输入账号~"
        _accountTF.font = UIFont.systemFont(ofSize: 15.0)
        _accountTF.keyboardType = .numberPad
        return _accountTF
    }()
    
    private lazy var passwordTF: UITextField = {
        let _passwordTF = UITextField()
        _passwordTF.placeholder = "输入密码~"
        _passwordTF.font = UIFont.systemFont(ofSize: 15.0)
        _passwordTF.keyboardType = .asciiCapable
        return _passwordTF
    }()
    
    init(_ environments: [String]?, clickConfirmHandler: @escaping (String?, String?, String) -> Void) {
        super.init(frame: UIScreen.main.bounds)
        self.environments = environments
        self.clickConfirmHandler = clickConfirmHandler
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalTo(260.0)
            make.height.equalTo(230.0)
            make.center.equalToSuperview()
        }
//        contentView.hz_viewWithCornerRadius(radius: 8.0)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8.0
        let titleLabel = UILabel()
        titleLabel.text = "输入账号密码"
        titleLabel.textColor = UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(accountTF)
        accountTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.right.equalToSuperview().offset(-10.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(15.0)
            make.height.equalTo(35.0)
        }
//        accountTF.hz_viewWithCornerRadiusBorder(radius: 4.0, borderColor: .ytTextThreeLevel, borderWidth: 0.7, corners: .allCorners)
        accountTF.layer.masksToBounds = true
        accountTF.layer.cornerRadius = 4.0
        accountTF.layer.borderColor = UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0).cgColor
        accountTF.layer.borderWidth = 0.5
        contentView.addSubview(passwordTF)
        passwordTF.snp.makeConstraints { make in
            make.left.right.height.equalTo(accountTF)
            make.top.equalTo(accountTF.snp.bottom).offset(10.0)
        }
//        passwordTF.hz_viewWithCornerRadiusBorder(radius: 4.0, borderColor: .ytTextThreeLevel, borderWidth: 0.7, corners: .allCorners)
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.cornerRadius = 4.0
        passwordTF.layer.borderColor = UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0).cgColor
        passwordTF.layer.borderWidth = 0.5
        let currentEnvironment = HZDebugTool.delegate?.debugToolOfCurrentEnvironment()
        if let _environments = environments {
            let buttonWidth = (260.0 - 20.0) / Double(_environments.count)
            _environments.enumerated().forEach { element in
                let button = UIButton(type: .custom)
                button.setTitle(element.element, for: .normal)
                button.setTitleColor(UIColor(red: 124.0/255.0, green: 126.0/255.0, blue: 128.0/255.0, alpha: 1.0), for: .normal)
                button.setTitleColor(UIColor(red: 73.0/255.0, green: 79.0/255.0, blue: 245.0/255.0, alpha: 1.0), for: .selected)
                button.setImage(UIImage(named: "icon_selectedIcon_un"), for: .normal)
                button.setImage(UIImage(named: "icon_selectedIcon"), for: .selected)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
                button.contentMode = .center
                if element.element == currentEnvironment  {
                    button.isSelected = true
                    self.selectButton = button
                    self.selectedEnvironment = element.element
                }else if element.offset == 0, let _currentEnvironment = currentEnvironment, !_environments.contains(_currentEnvironment) {
                    button.isSelected = true
                    self.selectButton = button
                    self.selectedEnvironment = element.element
                }
                button.addTarget(self, action: #selector(clickEnvironmentButtonAction(_:)), for: .touchUpInside)
                button.tag = 2022030300 + element.offset
                contentView.addSubview(button)
                button.snp.makeConstraints { make in
                    make.width.equalTo(buttonWidth)
                    make.height.equalTo(50.0)
                    make.left.equalToSuperview().offset(10.0 + buttonWidth * Double(element.offset))
                    make.top.equalTo(passwordTF.snp.bottom).offset(10.0)
                }
            }
        }
        let btnConfirm = UIButton(type: .custom)
        btnConfirm.setTitle("确认", for: .normal)
        btnConfirm.setTitleColor(UIColor(red: 73.0/255.0, green: 79.0/255.0, blue: 245.0/255.0, alpha: 1.0), for: .normal)
        btnConfirm.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        let btnCancel = UIButton(type: .custom)
        btnCancel.setTitle("取消", for: .normal)
        btnCancel.setTitleColor(UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0), for: .normal)
        btnCancel.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        contentView.addSubview(btnConfirm)
        contentView.addSubview(btnCancel)
        btnConfirm.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40.0)
        }
        btnCancel.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.width.equalTo(btnConfirm)
        }
        btnConfirm.addTarget(self, action: #selector(clickConfirmButtonAction), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(clickCancelButtonAction), for: .touchUpInside)
        
        /// 键盘即将弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        /// 键盘即将消失
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        guard let height = keyboardFrame?.size.height else { return }
        let contentViewFrame = contentView.frame
        if (self.bounds.size.height - contentViewFrame.size.height) / 2.0 < height {
            contentView.snp.remakeConstraints { make in
                make.width.equalTo(260.0)
                make.height.equalTo(230.0)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(height)
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        contentView.snp.remakeConstraints { make in
            make.width.equalTo(260.0)
            make.height.equalTo(230.0)
            make.center.equalToSuperview()
        }
    }
    
    @objc func clickConfirmButtonAction() {
        self.clickConfirmHandler?(self.accountTF.text, self.passwordTF.text, self.selectedEnvironment)
        self.removeFromSuperview()
    }
    
    @objc func clickCancelButtonAction() {
        self.removeFromSuperview()
    }
    
    @objc func clickEnvironmentButtonAction(_ sender: UIButton) {
        let index = sender.tag - 2022030300
        if let _environments = self.environments, index < _environments.count {
            self.selectedEnvironment = _environments[index]
            self.selectButton?.isSelected = false
            sender.isSelected = true
            self.selectButton = sender
        }
    }
    
}
