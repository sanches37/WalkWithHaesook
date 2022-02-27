//
//  FireStoreManager.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/28.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FireStoreManager {
    private let db = Firestore.firestore()
    private let path = "WorkList"
    
    func fetch<T: Decodable>(completion: @escaping (Result<[T], FireSotreError>) -> Void) {
        db.collection(path).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(.unknown(description: error.localizedDescription)))
                return
            }
            guard let snapshot = snapshot?.documents else {
                completion(.failure(.dataNotfound))
                return
            }
            let dataArray = snapshot.compactMap { quary -> T? in
                guard let data = try? quary.data(as: T.self) else {
                    completion(.failure(.decodingFailed))
                    return nil
                }
                return data
            }
            completion(.success(dataArray))
        }
    }
}
