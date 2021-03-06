//
//  MessageListViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/07/05.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Salada
import Firebase
import DZNEmptyDataSet
import RAMAnimatedTabBarController

class MessageListViewController: UIViewController {
    
    @IBOutlet weak var messageListTableView: UITableView!
    private var dataSource: DataSource<FirebaseApp.User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(false)
        if let indexPathForSelectedRow = messageListTableView.indexPathForSelectedRow {
            messageListTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    private func setTableView() {
        self.messageListTableView.tableFooterView = UIView(frame: .zero)
        FirebaseApp.User.current { user in
            self.messageListTableView.register(UINib(nibName: "MessageListCell", bundle: nil), forCellReuseIdentifier: "cell")
            let options: Options = Options()
            self.dataSource = DataSource(reference: (user?.matches.ref)!, options: options, block: { [weak self](changes) in
                guard let tableView: UITableView = self?.messageListTableView else { return }
                
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
            })
        }
    }

}

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageListCell
        if let user = self.dataSource?.objects[indexPath.item] {
            cell.userNameLabel.text = user.nickName
            cell.userAgeLabel.text = user.age.description + "歳"
            cell.userLocateLabel.text = user.residence
            cell.userPositionLabel.text = user.position
            cell.userFigureLabel.text = user.figure
            cell.userMutterLabel.text = user.mutter
            if let ref: StorageReference = user.thumbnail?.ref {
                cell.userImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "nil-image"))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell: MessageListCell = cell as? MessageListCell {
            cell.disposer?.dispose()
        }
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if let user: FirebaseApp.User = self.dataSource?.objects[indexPath.item] {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let naviView = storyboard.instantiateViewController(withIdentifier: "messageViewNavigation") as! UINavigationController
            let view = naviView.topViewController as! MessageViewController
            view.opponentUser = user
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
}

extension MessageListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "まだマッチしていません。"
        let font = UIFont(name: "Helvetica", size: 20)!
        return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "heart-red.png")
    }
}
