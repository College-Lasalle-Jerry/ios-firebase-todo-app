//
//  Todo.swift
//  Firebase Todo App
//
//  Created by Jerry Joy on 2024-10-30.
//

import Foundation
import FirebaseFirestore


struct Todo: Identifiable, Codable{
    @DocumentID var id: String? // Firestore will create this, so we use ?
    var title: String
    var isDone: Bool

}
