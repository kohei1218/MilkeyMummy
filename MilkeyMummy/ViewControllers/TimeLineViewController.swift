//
//  TimeLineViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/15.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import Firebase
import Salada
import FirebaseStorageUI
import RAMAnimatedTabBarController

class TimeLineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: DataSource<FirebaseApp.User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        setCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(false)
    }
    
    private func setCollectionView() {
        FirebaseApp.User.current { user in
            self.collectionView.register(UINib(nibName: "TimeLineCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            let options: Options = Options()
            if user?.gender == "male" {
                options.predicate = NSPredicate(format: "gender == 'female'")
            } else {
                options.predicate = NSPredicate(format: "gender == 'male'")
            }
            options.sortDescirptors = [NSSortDescriptor(key: "mutterDate", ascending: false)]
            self.dataSource = DataSource(reference: FirebaseApp.User.databaseRef, options: options, block: { [weak self](changes) in
                guard let collectionView: UICollectionView = self?.collectionView else { return }
                switch changes {
                case .initial:
                    self?.collectionView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                        collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                        collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    }, completion: nil)
                case .error(let error):
                    print(error)
                }
            })
        }
    }
    
}

extension TimeLineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource?.count == nil {
            return 0
        }
        return (self.dataSource?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 2 - 4
        let height = UIScreen.main.bounds.width / 2 + 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TimeLIneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeLIneCell
        configure(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0 , 2 , 20 , 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user: FirebaseApp.User = self.dataSource?.objects[indexPath.item] {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let naviView = storyboard.instantiateViewController(withIdentifier: "timeLineDetailNavigation") as! UINavigationController
            let view = naviView.topViewController as! TimeLineDetailViewController
            view.opponentUser = user
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    func configure(_ cell: TimeLIneCell, atIndexPath indexPath: IndexPath) {
        if let user: FirebaseApp.User = self.dataSource?.objects[indexPath.item] {
            cell.mutterLabel.text = user.mutter
            cell.profileLabel.text = (user.nickName)! + ""
            if let ref: StorageReference = user.thumbnail?.ref {
                cell.profileImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "loading-appcolor"))
            }
        }
    }
    
}
