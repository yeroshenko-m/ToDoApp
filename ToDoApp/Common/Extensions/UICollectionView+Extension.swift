//
//  UICollectionView extension.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.02.2021.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableItem(withModel model: CellViewAnyModel,
							 for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = type(of: model).cellAnyType.reuseIdentifier
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier,
											for: indexPath)
        model.setupAny(cell: cell)
        return cell
    }
    
}
