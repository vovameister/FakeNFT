//
//  AlertCatalogView.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 05.02.2024.
//
import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let actionTitles: [String]
}

protocol AlertCatalogView {
    func openAlert(
        title: String,
        message: String?,
        alertStyle: UIAlertController.Style,
        actionTitles: [String],
        actionStyles: [UIAlertAction.Style],
        actions: [((UIAlertAction) -> Void)]
    )
}

extension UIViewController {
    func openAlert(
        title: String,
        message: String?,
        alertStyle: UIAlertController.Style,
        actionTitles: [String],
        actionStyles: [UIAlertAction.Style],
        actions: [((UIAlertAction) -> Void)]){
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: alertStyle)
        
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(
                title: indexTitle,
                style: actionStyles[index],
                handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}
