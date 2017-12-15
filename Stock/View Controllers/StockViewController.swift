//
//  StockViewController.swift
//  Stock
//
//  Created by Kim Younghoo on 12/7/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit
//[C3-7]
import SafariServices
import SVProgressHUD

class StockViewController: UIViewController {
    
    let stock: Stock
    
    @IBOutlet weak var tableView: UITableView!
    
    //[C1-4]
    var amountField: UITextField?
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = stock.name
        
        //[C1-9]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveStock))
        
        tableView.backgroundColor = .backgroundView
        tableView.separatorColor = .separator
        tableView.hideBottomSeparator()
        tableView.register(UINib(nibName: StockInfoTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: StockInfoTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: StockChartTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: StockChartTableViewCell.reuseIdentifier)
        //[C1-3]
        tableView.register(UINib(nibName: TextFieldTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        //[C4-14]
        tableView.register(DeleteTableViewCell.self, forCellReuseIdentifier: DeleteTableViewCell.reuseIdentifier)
    }
    
    //[C1-11]
    @objc func saveStock() {
        if let amountText = amountField?.text, let amount = Int(amountText)  {
            amountField?.resignFirstResponder()
            SVProgressHUD.showSuccess(withStatus: "Saved")
            SVProgressHUD.dismiss(withDelay: 1)
            stock.amount = amount
            NotificationCenter.default.post(name: Stock.didUpdate, object: nil)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //[C6-17]
        tableView.reloadData()
        
        //[C2-2]
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //[C2-8]
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //[C2-3]
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardData = notification.keyboardData else { return }
        
        let keyboardFrame = keyboardData.frame
        let hiddenHeight = view.frame.height - keyboardFrame.origin.y
        
        //[C2-6]
        UIView.animate(withDuration: keyboardData.animationDuration, delay: 0, options: keyboardData.animationCurve, animations: {
            self.tableView.contentInset.bottom = hiddenHeight
            self.tableView.scrollIndicatorInsets.bottom = hiddenHeight
        }, completion:nil)
    }
    
    //[C2-3]
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let keyboardData = notification.keyboardData else { return }
        
        //[C2-7]
        UIView.animate(withDuration: keyboardData.animationDuration, delay: 0, options: keyboardData.animationCurve, animations: {
            self.tableView.contentInset.bottom = 0
            self.tableView.scrollIndicatorInsets.bottom = 0
        }, completion: nil)
    }
}

extension StockViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //[C3-1]
        //return 2
        
        //[C4-1]
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ///[C1-2]
        //return 4
        
        //[C3-2]
        //if section == 0 {
        //    return 4
        //} else if {
        //    return 3
        //}
        
        if section == 0 {
            //[C5-2]
            return 5
        } else if section == 1 {
            return 3
        } else if section == 2 {
            //[C4-2]
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //[C3-3]
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: StockInfoTableViewCell.reuseIdentifier, for: indexPath) as! StockInfoTableViewCell
                cell.stock = stock
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: StockChartTableViewCell.reuseIdentifier, for: indexPath) as! StockChartTableViewCell
                cell.stock = stock
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 2 {
                //[C1-5]
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                amountField = cell.textField
                cell.label.text = "보유수량"
                cell.textField.placeholder = "종목 보유수량"
                cell.textField.text = "\(stock.amount)"
                //[C1-7]
                cell.textField.isEnabled = true
                //[C1-8]
                cell.textField.keyboardType = .numberPad
                //[C5-3]
                cell.accessoryType = .none
                return cell
            }  else if indexPath.row == 3 {
                //[C1-6]
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.label.text = "평가금액"
                cell.textField.text = "\(stock.value)"
                cell.textField.isEnabled = false
                //[C5-3]
                cell.accessoryType = .none
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.label?.text = "그룹"
                cell.textField?.placeholder = "종목 그룹선택"
                cell.textField?.text = stock.groupTitle
                cell.textField?.isEnabled = false
                //[C5-3]
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        } else if indexPath.section == 1 {
            //[C3-4]
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.reuseIdentifier)
            }
            
            //[C3-5]
            cell.textLabel?.font = .systemFont(ofSize: 15)
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell.textLabel?.text = "네이버 증권"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "다음 금융"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Bloomberg"
            }
            return cell
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
            //[C4-3]
            //var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier)
            //if cell == nil {
            //    cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.reuseIdentifier)
            //}
            //[C4-4]
            //cell.textLabel?.font = .systemFont(ofSize: 15)
            //cell.textLabel?.textColor = .red
            //cell.textLabel?.textAlignment = .center
            
            //[C4-15]
            let cell = tableView.dequeueReusableCell(withIdentifier: DeleteTableViewCell.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = "종목 삭제"
            
            return cell
        }

        return UITableViewCell()
    }
}

extension StockViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                //[C10-18]
                let chartsViewController = ChartsViewController(stock: stock)
                navigationController?.pushViewController(chartsViewController, animated: true)
            } else if indexPath.row == 4 { //[C6-13]
                if let groups = AppDelegate.shared.groupsViewController?.groups {
                    //[C6-17]
                    let selectGroupViewController = SelectGroupViewController(groups: groups, stock: stock)
                    navigationController?.pushViewController(selectGroupViewController, animated: true)
                }
            }
        } else if indexPath.section == 1 {
            //[C3-7]
            var urlString: String?
            if indexPath.row == 0 {
                urlString = "http://finance.naver.com/item/main.nhn?code=\(stock.code)"
            } else if indexPath.row == 1 {
                urlString = "http://finance.daum.net/item/main.daum?code=" + stock.code
            } else if indexPath.row == 2 {
                urlString = "https://www.bloomberg.com/quote/\(stock.code):KS"
            }
            if let urlString = urlString, let url = URL(string: urlString) {
                present(SFSafariViewController(url: url), animated: true, completion: nil)
            }
        } else if indexPath.section == 2 && indexPath.row == 0 {
            //[C4-6]
            let alert = UIAlertController(title: "종목삭제", message: "종목을 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                NotificationCenter.default.post(name: Stock.didDelete, object: self.stock)
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //[C3-6]
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //[C3-6]
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        view.backgroundColor = .clear
        return view
    }
}
