//
//  ViewController.swift
//  MenuDemo
//
//  Created by kaiya on 2020/11/16.
//

import UIKit

class ViewController: UIViewController {

    lazy var menuView : MenuView = {
        let view = MenuView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 40))
        view.backgroundColor = UIColor.red
        view.menuTableView.backgroundColor = UIColor.yellow
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(menuView)
        menuView.titleArray = ["新闻","体育","夏洛特烦恼","满城尽带黄金甲","歌曲","农业","社会","鸡你太美"]
        menuView.menuClickItem = { index in
            print("点击了按钮==>\(index)")
        }
        
        
    }


}

