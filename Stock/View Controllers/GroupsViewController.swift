import UIKit

class GroupsViewController: UIViewController {

    let segmentedControl = UISegmentedControl(items: ["그룹", "종목"])
    
    @IBOutlet weak var tableView: UITableView!
    
    var groups: [Group] = [Group(title: "성장", note: "성장하는 종목들")]
    var stocks: [Stock] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteGroup(_:)), name: Group.didDelete, object: nil)
        
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-add_folder"), style: .plain, target: self, action: #selector(newGroup))
        
        tableView.separatorColor = .separator
        tableView.hideBottomSeparator()
        tableView.register(UINib(nibName: GroupTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: GroupTableViewCell.reuseIdentifier)
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 1 {
            tabBarController?.selectedIndex = segmentedControl.selectedSegmentIndex
        }
    }
    
    @objc func deleteGroup(_ notification: Notification) {
        guard let groupToDelete = notification.object as? Group else { return }
        guard let index = groups.index(where: { $0.title == groupToDelete.title }) else { return }
        
        removeGroupAt(index)
    }
    
    @IBAction func newGroup() {
        let editGroupViewController = EditGroupViewController(group: nil)
        
        editGroupViewController.didSaveGroup = { group in
            self.groups.append(group)
            self.saveGroups()
        }
        let navigationController = UINavigationController(rootViewController: editGroupViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func reload() {
        if let data = UserDefaults.standard.object(forKey: "groups") as? Data {
            groups = try! PropertyListDecoder().decode([Group].self, from: data)
        }
        
        if let data = UserDefaults.standard.object(forKey: "stocks") as? Data {
            stocks = try! PropertyListDecoder().decode([Stock].self, from: data)
        }
        
        tableView.reloadData()
    }
    
    func saveGroups() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(groups), forKey: "groups")
        UserDefaults.standard.synchronize()
    }
    
    private func removeGroupAt(_ index: Int) {
        groups.remove(at: index)
        saveGroups()
        tableView.reloadData()
    }
}

extension GroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeGroupAt(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseIdentifier, for: indexPath) as! GroupTableViewCell
        let group = groups[indexPath.row]
        cell.group = group
        cell.stocks = stocks.filter { $0.groupTitle == group.title }
        return cell
    }
}

extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editGroupViewController = EditGroupViewController(group: groups[indexPath.row])
        editGroupViewController.didSaveGroup = { group in
            self.saveGroups()
            self.tableView.reloadData()
        }
        let navigationController = UINavigationController(rootViewController: editGroupViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
