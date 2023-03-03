//
//  HZAlertController.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/3.
//

import UIKit

class HZAlertController {

    static func showInputBox(_ message: String, title: String, placeholder: String = "输入请求版本号", confirmButtonTitle: String = "确定", textFieldText: String? = nil, confirmHandler: ((String) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertContentVC = UIViewController()
            UIApplication.shared.keyWindow?.addSubview(alertContentVC.view)
            let alertVc: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: confirmButtonTitle, style: .default) { (action) in
                if let textField = alertVc.textFields?.first, let _text = textField.text, _text.count > 0 {
                    if let _confirmHandler = confirmHandler {
                        _confirmHandler(_text)
                    }
//                    else if project == .ytky {
//                        YTRequestConfig.ytkyDebugVersion = "/v\(_text)"
//                    }else if project == .auth {
//                        YTRequestConfig.authDebugVersion = "/v\(_text)"
//                    }
                }
                alertContentVC.view.removeFromSuperview()
            }
            confirmAction.setValue(UIColor(red: 73.0/255.0, green: 79.0/255.0, blue: 244.0/255.0, alpha: 1.0), forKey: "titleTextColor")
            let messageAttributes = NSMutableAttributedString(string: "\n" + message)
            messageAttributes.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)], range: NSRange(location: 0, length: messageAttributes.length))
            messageAttributes.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 10.0/255.0, green: 13.0/255.0, blue: 15.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: messageAttributes.length))
            alertVc.setValue(messageAttributes, forKey: "attributedMessage")
            alertVc.addTextField { textField in
                textField.placeholder = placeholder
                if let _textFieldText = textFieldText {
                    textField.text = _textFieldText
                }
//                if project == .ytky {
//                    textField.text = "\(YTRequestConfig.ytkyDebugVersion.dropFirst(2))"
//                }else if project == .auth {
//                    textField.text = "\(YTRequestConfig.authDebugVersion.dropFirst(2))"
//                }
            }
            alertVc.addAction(confirmAction)
            alertContentVC.present(alertVc, animated: true)
        }
    }
    
}
