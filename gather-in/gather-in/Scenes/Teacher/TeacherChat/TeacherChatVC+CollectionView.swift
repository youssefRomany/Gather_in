//
//  TeacherChatVC+CollectionView.swift
//  gather-in
//
//  Created by Ramzy on 08/01/2021.
//

import UIKit

extension TeacherChatVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
       membersCollectionView.dataSource = self
       membersCollectionView.delegate = self
       membersCollectionView.registerCell(cellClass: MemberCollectionCell.self)
   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as MemberCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
