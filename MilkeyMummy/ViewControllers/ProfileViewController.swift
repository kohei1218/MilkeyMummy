//
//  ProfileViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/07/05.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Firebase
import IBAnimatable

class ProfileViewController: UIViewController {
    
    enum SectionType: Int {
        case profile
        case other
    }
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var profileImageView: AnimatableImageView!
    @IBOutlet weak var mutterLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    private let others: Array = ["利用規約", "プライバシーポリシー", "問い合わせ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTableView.tableFooterView = UIView(frame: .zero)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        FirebaseApp.User.current { user in
            if let ref: StorageReference = user?.thumbnail?.ref {
                self.profileImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "nil-image"))
            }
            self.nickNameLabel.text = user?.nickName
            self.mutterLabel.text = user?.mutter
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.profile.rawValue:
            return "プロフィール"
        case SectionType.other.rawValue:
            return "その他"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.profile.rawValue:
            return 1
        case SectionType.other.rawValue:
            return others.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case SectionType.profile.rawValue:
            cell.textLabel?.text = "プロフィールの変更"
        case SectionType.other.rawValue:
            cell.textLabel?.text = others[indexPath.row]
        default: break
        }
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        
    }
    
    
}
