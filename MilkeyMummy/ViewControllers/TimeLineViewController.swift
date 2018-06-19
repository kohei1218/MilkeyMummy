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

class TimeLineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: DataSource<FirebaseApp.User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib: UINib = UINib(nibName: "TimeLineViewCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "TimeLineCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        let options: Options = Options()
        options.limit = 10
        options.predicate = NSPredicate(format: "gender == 'male'")
//        options.sortDescirptors = [NSSortDescriptor(key: "age", ascending: false)]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TimeLineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width / 2 - 4
        let height = UIScreen.main.bounds.width / 2 + 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TimeLIneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeLIneCell
//        cell.profileImageView.image = UIImage(named: "tab-timeline")
//        cell.profileLabel.text = "ちゃす"
        configure(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20 , 2 , 20 , 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func configure(_ cell: TimeLIneCell, atIndexPath indexPath: IndexPath) {
        cell.disposer = self.dataSource?.observeObject(at: indexPath.item, block: { (user) in
            cell.profileLabel.text = user?.nickName
        })
    }
    
}
