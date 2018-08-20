//
//  ChatViewController.swift
//  LetsTeamApp
//
//  Created by admin on 8/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    var eventId: String?
    //var dateChildNode = "16082018"
    var ut:Utills = Utills.shared
    var viewModal:EventListViewModal = EventListViewModal.shared
    
    var refChatRoom: DatabaseReference!
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventId = (viewModal.selectedEvent?.Id)!
        self.senderId = viewModal.userid
        self.senderDisplayName = viewModal.userName
        self.collectionView.backgroundColor = UIColor(red: 204, green: 191, blue: 255, alpha: 1) //UIImageView(image: UIImage(named: "chatB"))
        refChatRoom = Database.database().reference().child("ChatRooms").child(self.eventId!);
        
        //senderId = "1234"
        //senderDisplayName="HelloWorld"
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        // Do any additional setup after loading the view.
        
        let query = refChatRoom.child("messages").child(self.ut.dateToFlatString()).queryOrdered(byChild: "CreationDate").queryLimited(toLast: 20)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data = snapshot.value as? [String: String],
                let id = data["senderId"],
                let name = data["senderName"],
                let text = data["message"],
                let date = self?.ut.stringToDate(date: data["CreationDate"]!),
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, text: text)
                {
                    
                    self?.messages.append(message)
                    
                    self?.messages.sorted(by: {$0.date > $1.date})
                    
                    self?.finishReceivingMessage()
                }
            }
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return  NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        //return 17.0
        let message = messages[indexPath.item]
        
           
            return 17.0
            
        
    }

   
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let ref = self.refChatRoom.child("messages").child(self.ut.dateToFlatString()).childByAutoId()
        let messageToSave = ["senderId": senderId, "senderName": senderDisplayName, "message": text,"CreationDate": ut.dateToString(date: date)]

        ref.setValue(messageToSave)
        
        var message:JSQMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) //senderId: senderId, displayName: senderDisplayName, text: text)
        
      //  self.messages.append(message)
        finishSendingMessage()
    }

}
