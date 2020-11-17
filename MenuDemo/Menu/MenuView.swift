//
//  MenuView.swift
//  MenuDemo
//
//  Created by kaiya on 2020/11/16.
//

import UIKit

typealias menuClickItemBLock = (_ index : Int)->()

class MenuView: UIView {
    
    var menuClickItem : menuClickItemBLock?
    
    var defultTextColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    var hightLightTextColor = UIColor(red: 10/255, green: 142/255, blue: 160/255, alpha: 1)
    var bottomLineHeight = 4
    var bottomLineWidth = 20
    
    var titleFontSize : CGFloat?
    var _titleArray : Array<String>?
    var titleArray : Array<String>{
        set{
            _titleArray = newValue
            menuTableView.reloadData()
        }
        get{
            return _titleArray ?? []
        }
    }
    
    lazy var menuTableView : UITableView = {
        let tb = UITableView()
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.bounces = false
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        return tb
    }()
    
    lazy var menuBottomLine : UIView = {
        let v = UIView()
        v.backgroundColor = hightLightTextColor
        v.layer.cornerRadius = CGFloat(bottomLineHeight/2)
        return v
    }()
    
    lazy var menuBottomBorder : UIView = {
        let bb = UIView()
        bb.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        return bb
    }()
    
    var currentIndexPath : IndexPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        menuTableView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.addSubview(menuTableView)
        self.addSubview(menuBottomBorder)
        menuBottomBorder.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MenuView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for i in 0..<titleArray.count {
            tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell\(i)")
        }
        
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuCell\(indexPath.row)", for: indexPath) as! MenuTableViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        cell.selectionStyle = .none
        cell.titleLabel.text = titleArray[indexPath.row]
        
        
        cell.titleLabel.textColor = defultTextColor
        
        if let iP = currentIndexPath {
            if indexPath.row == iP.row {
                cell.contentView.addSubview(menuBottomLine)
                menuBottomLine.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(bottomLineWidth)
                    make.height.equalTo(bottomLineHeight)
                }
                cell.titleLabel.textColor = hightLightTextColor
            }
        }else{
            if indexPath.row == 0  {
                cell.contentView.addSubview(menuBottomLine)
                menuBottomLine.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(bottomLineWidth)
                    make.height.equalTo(bottomLineHeight)
                }
                cell.titleLabel.textColor = hightLightTextColor
            }
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = titleArray[indexPath.row]
        let width = title.getSizeFor(text: title as NSString, height: self.bounds.size.height, fontSize: 15)
        
        return width + 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<titleArray.count {
            
            if let cell : MenuTableViewCell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? MenuTableViewCell {
                //menuBottomLine.removeFromSuperview()
                cell.titleLabel.textColor = defultTextColor
            }
        }
        if let cell : MenuTableViewCell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell {
            cell.contentView.addSubview(menuBottomLine)
            menuBottomLine.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(bottomLineWidth)
                make.height.equalTo(bottomLineHeight)
            }
            cell.titleLabel.textColor = hightLightTextColor
        }
        
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
        
        currentIndexPath = indexPath
        
        if let block = menuClickItem {
            block(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
}


class MenuTableViewCell: UITableViewCell {
    
    let defultColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    lazy var titleLabel : UILabel = {
        let lb = UILabel()
        lb.textColor = defultColor
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textAlignment = .center
        //lb.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension String {
    func getSizeFor(text : NSString,height: CGFloat,fontSize : CGFloat) -> CGFloat{
       let rect =  text.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        return rect.size.width
    }
}
