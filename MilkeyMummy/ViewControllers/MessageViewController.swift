//
//  MessageViewController.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/07/05.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import RAMAnimatedTabBarController
import Salada

class MessageViewController: JSQMessagesViewController {
    

    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    var opponentUser: FirebaseApp.User?
    private var dataSource: DataSource<Message>?
    private var user: FirebaseApp.User?
    private var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        navigationItem.title = opponentUser?.nickName
        
        if #available(iOS 11.0, *){ self.collectionView.contentInsetAdjustmentBehavior = .never; self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 40, 0); self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset }
        
        inputToolbar!.contentView!.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0, height: 0)
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        observeFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(true)
    }
    
    private func observeFirebase() {
        FirebaseApp.User.current { user in
            self.user = user
            self.senderId = user?.id
            var roomid: String?
            if user?.gender == "male" {
                roomid = (user?.id)! + (self.opponentUser?.id)!
            } else {
                roomid = (self.opponentUser?.id)! + (user?.id)!
            }
            Room.observeSingle(roomid!, eventType: .value, block: { (room) in
                self.room = room
                let options: Options = Options()
                options.sortDescirptors = [NSSortDescriptor(key: "postDate", ascending: true)]
                self.dataSource = DataSource(reference: (room?.messages.ref)!, options: options, block: { [weak self](changes) in
                    guard let collectionView: UICollectionView = self?.collectionView else { return }
                    switch changes {
                    case .initial:
                        self?.collectionView.reloadData()
                        self?.collectionView.setContentOffset(CGPoint(x: 0, y: 2000), animated: false)
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
                self.finishSendingMessage()
            })
        }
    }
    
    private func initMessageData(indexPath: IndexPath) -> JSQMessage {
        let message = self.dataSource?.objects[indexPath.item]
        var messageData: JSQMessage?
        if user?.id == message?.senderId {
            messageData = JSQMessage(senderId: user?.id, displayName: user?.nickName, text: message?.text)
        } else {
            messageData = JSQMessage(senderId: opponentUser?.id, displayName: opponentUser?.nickName, text: message?.text)
        }
        return messageData!
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        self.finishReceivingMessage(animated: true)
        
        if let _ = self.room {
            let message = Message()
            message.text = text
            message.senderId = user?.id
            message.postDate = Date()
            message.save()
            room?.messages.insert(message)
            self.finishSendingMessage(animated: true)
        }
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return initMessageData(indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) ->
        JSQMessageBubbleImageDataSource {
            if initMessageData(indexPath: indexPath).senderId == self.user?.id {
                return self.outgoingBubble
            }
            return self.incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = initMessageData(indexPath: indexPath)
        if message.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource?.count == nil {
            return 0
        }
        return (self.dataSource?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if let ref: StorageReference = opponentUser?.thumbnail?.ref {
            cell.avatarImageView.sd_setImage(with: ref, placeholderImage: UIImage(named: "nil-image"))
        }
        return cell
    }
    
}
