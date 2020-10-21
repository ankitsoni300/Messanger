//
//  ChatViewController.swift
//  Messanger
//
//  Created by Ankit Soni on 14/10/20.
//  Copyright © 2020 imart. All rights reserved.
//

import UIKit
import MessageKit

struct Message : MessageType {
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

struct Sender : SenderType {
    var senderId: String
    var displayName: String
    var photoURL : String
}


class ChatViewController: MessagesViewController {

    private var message = [Message]()
    private let selfSender = Sender(senderId: "1",
                                    displayName: "Ankit Soni",
                                    photoURL: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        message.append(Message(sender: selfSender,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text("Hello I am Ankit")))
        message.append(Message(sender: selfSender,
                               messageId: "1",
                               sentDate: Date(),
                               kind: .text("Hello I am Ankit. Hello World, Hello World, Hello World")))
    }

}

extension ChatViewController : MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource{
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return message[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return message.count
    }
    
    
}
