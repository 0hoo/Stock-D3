//
//  StocksViewController.swift
//  Stock
//
//  Created by Kim Younghoo on 12/5/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Kanna

//[C7-2]
class StockSection {
    var group: Group?
    var stocks: [Stock] = []
    
    init(group: Group?, stocks: [Stock]) {
        self.group = group
        self.stocks = stocks
    }
}

class StocksViewController: UIViewController {
    
    let segmentedControl = UISegmentedControl(items: ["그룹", "종목"])
    
    @IBOutlet weak var tableView: UITableView!
    
    //[C7-3]
    var stockSections: [StockSection] = []
    var stocks: [Stock] = []
    
    
    //[C12-1]
    let refreshControl = UIRefreshControl()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //[C1-12]
        NotificationCenter.default.addObserver(self, selector: #selector(saveStocks), name: Stock.didUpdate, object: nil)
        //[C4-7]
        NotificationCenter.default.addObserver(self, selector: #selector(deleteStock(_:)), name: Stock.didDelete, object: nil)
        
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshStocks))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-add"), style: .plain, target: self, action: #selector(newStock))
        
        tableView.separatorColor = .separator
        tableView.register(UINib(nibName: StockTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: StockTableViewCell.reuseIdentifier)
        //[C8-24]
        tableView.register(UINib(nibName: StockHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: StockHeaderView.reuseIdentifier)
        tableView.hideBottomSeparator()
        //[C12-2]
        tableView.addSubview(refreshControl)
        //[C12-3]
        refreshControl.addTarget(self, action: #selector(refreshStocks), for: .valueChanged)
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //[C1-13]
        //tableView.reloadData()
        
        //[C7-14]
        reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        segmentedControl.selectedSegmentIndex = 1
    }
    
    @objc func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            tabBarController?.selectedIndex = segmentedControl.selectedSegmentIndex
        }
    }
    
    @objc func newStock() {
        let alertController = UIAlertController(title: "새 종목", message: "종목코드를 입력하세요", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "종목코드"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let code = alertController.textFields?[0].text, !code.isEmpty else { return }
            self?.searchStock(code: code)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    //[C4-8]
    @objc func deleteStock(_ notification: Notification) {
        guard let stock = notification.object as? Stock else { return }
        guard let index = stocks.index(where: { $0.name == stock.name }) else { return }
        stocks.remove(at: index)
        saveStocks()
        //reload()
    }
    
    func searchStock(code: String) {
        parseStock(code: code) { stock in
            self.stocks.append(stock)
            self.saveStocks()
            //self.tableView.reloadData()
        }
    }
    
    func parseStock(code: String, success: @escaping ((Stock) -> Void)) {
        let siteUrl = "http://finance.daum.net/item/main.daum?code=" + code
        Alamofire.request(siteUrl).responseString { response in
            SVProgressHUD.dismiss()
            //[C12-4]
            self.refreshControl.endRefreshing()
            
            guard let html = response.result.value else { return }
            guard let doc = try? HTML(html: html, encoding: .utf8) else { return }
            guard let titleElement = doc.at_css("#topWrap > div.topInfo > h2") else { return }
            guard let title = titleElement.content else { return }
            guard let priceElement = doc.at_css("#topWrap > div.topInfo > ul.list_stockrate > li:nth-child(1) > em") else { return }
            guard let priceString = priceElement.content else { return }
            guard let price = Double(priceString.replacingOccurrences(of: ",", with: "")) else { return }
            
            let priceKeep = priceElement.className?.hasSuffix("keep") == true
            let priceUp = priceElement.className?.hasSuffix("up") == true
            let priceDiffString = doc.at_css("#topWrap > div.topInfo > ul.list_stockrate > li:nth-child(2) > span")?.content ?? ""
            let priceDiff = Double(priceDiffString.replacingOccurrences(of: ",", with: "")) ?? 0
            var rateDiffString = doc.at_css("#topWrap > div.topInfo > ul.list_stockrate > li:nth-child(3) > span")?.content ?? ""
            if rateDiffString.hasSuffix("％") || rateDiffString.hasSuffix("%") {
                rateDiffString = String(rateDiffString.dropLast())
            }
            if rateDiffString.hasPrefix("+") || rateDiffString.hasPrefix("-") {
                rateDiffString = String(rateDiffString.dropFirst())
            }
            let rateDiff = Double(rateDiffString.replacingOccurrences(of: ",", with: "")) ?? 0
            let exchange = doc.at_css("#topWrap > div.topInfo > ul.list_stockinfo > li:nth-child(2) > a")?.content
            
            let stock = Stock(name: title, code: code, price: price, isPriceUp: priceUp, isPriceKeep: priceKeep, priceDiff: priceDiff, rateDiff: rateDiff, exchange: exchange)
            stock.dayChartImageUrl = URL(string: doc.at_css("#stockGraphBody1")?["src"] ?? "")
            stock.monthChartImageUrl = URL(string: doc.at_css("#stockGraphBody2")?["src"] ?? "")
            stock.threeMonthsChartImageUrl = URL(string: doc.at_css("#stockGraphBody3")?["src"] ?? "")
            stock.yearChartImageUrl = URL(string: doc.at_css("#stockGraphBody4")?["src"] ?? "")
            stock.threeYearsChartImageUrl = URL(string: doc.at_css("#stockGraphBody5")?["src"] ?? "")
            success(stock)
        }
    }
    
    @objc func refreshStocks() {
        var updated = 0
        
        if stocks.count > 0 {
            SVProgressHUD.show()
        }
        
        for stock in stocks {
            parseStock(code: stock.code) { updatedStock in
                stock.price = updatedStock.price
                stock.isPriceKeep = updatedStock.isPriceKeep
                stock.isPriceUp = updatedStock.isPriceUp
                stock.priceDiff = updatedStock.priceDiff
                stock.rateDiff = updatedStock.rateDiff
                stock.exchange = updatedStock.exchange
                stock.dayChartImageUrl = updatedStock.dayChartImageUrl
                stock.monthChartImageUrl = updatedStock.monthChartImageUrl
                stock.threeMonthsChartImageUrl = updatedStock.threeMonthsChartImageUrl
                stock.yearChartImageUrl = updatedStock.yearChartImageUrl
                stock.threeYearsChartImageUrl = updatedStock.threeYearsChartImageUrl
                updated += 1
                if updated == self.stocks.count {
                    SVProgressHUD.dismiss()
                    self.saveStocks()
                    //self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func saveStocks() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(stocks), forKey: "stocks")
        //[C7-13]
        reload()
    }
    
    func reload() {
        //[C7-4]
        guard let groups = AppDelegate.shared.groupsViewController?.groups else { return }
        guard let stocksData = UserDefaults.standard.object(forKey: "stocks") as? Data else { return }
        guard let stocks = try? PropertyListDecoder().decode([Stock].self, from: stocksData) else { return }
        self.stocks = stocks

        //[C7-5]
        stockSections.removeAll()
        
        //[C7-6]
        for group in groups {
            let stockSection = StockSection(group: group, stocks: stocks.filter({ $0.groupTitle == group.title }))
            if stockSection.stocks.count > 0 {
                stockSections.append(stockSection)
            }
        }
        
        //[C7-7]
        let noGroupStocks = stocks.filter({ $0.groupTitle == nil })
        if noGroupStocks.count > 0 {
            let stockSection = StockSection(group: nil, stocks: noGroupStocks)
            stockSections.insert(stockSection, at: 0)
        }
        
        
        //[C7-12]
        tableView.reloadData()
    }
}

extension StocksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //[C7-8]
        return stockSections.count
    }
    
    //[C8-25]
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if stockSections[section].group == nil {
            return nil
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: StockHeaderView.reuseIdentifier) as! StockHeaderView
            view.titleLabel?.text = stockSections[section].group?.title
            view.detailLabel?.text = "\(stockSections[section].stocks.count)종목"
            return view
        }
    }
    
    //[C7-16]
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return stockSections[section].group?.title
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //[C7-9]
        return stockSections[section].stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.reuseIdentifier, for: indexPath) as! StockTableViewCell
        //[C7-10]
        cell.stock = stockSections[indexPath.section].stocks[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //[C7-11]
        let stock = stockSections[indexPath.section].stocks[indexPath.row]
        navigationController?.pushViewController(StockViewController(stock: stock), animated: true)
    }
    
    //[C8-26]
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if stockSections[section].group == nil {
            return .leastNormalMagnitude
        }
        return 38
    }
}


