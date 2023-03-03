//
//  HZNavigationController.swift
//  HZDebugTool
//
//  Created by 何志志 on 2023/3/1.
//

import UIKit

class HZNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isTranslucent = false
        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18.0)]
        if #available(iOS 13.0, *) {
            self.modalPresentationStyle = .fullScreen
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = HZDebugTool.default.themeColor
            appearance.titleTextAttributes = titleTextAttributes
            appearance.shadowColor = .clear
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }else {
            self.navigationBar.barTintColor = HZDebugTool.default.themeColor
            self.navigationBar.titleTextAttributes = titleTextAttributes
            self.navigationBar.subviews.first?.alpha = 0
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
