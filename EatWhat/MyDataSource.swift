//
//  MyDataSource.swift
//  EatWhat
//
//  Created by Eros on 2017/3/20.
//  Copyright © 2017年 eros.chen. All rights reserved.
//

import UIKit

class StoreListCell: UITableViewCell {
    @IBOutlet weak var cellStoreName: UILabel!
    @IBOutlet weak var cellRate: UILabel!
    @IBOutlet weak var cellDistance: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    @IBOutlet weak var cellAddress: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBAction func cellActionCall(_ sender: Any) {
        
    }
}

class MyDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var resultList: [[String: Any]]?
    var imageData = Data()
    var phone: String?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let datasource = resultList {
            return datasource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListCell", for: indexPath) as! StoreListCell
        if let result = resultList {
            cell.cellStoreName.text = (result[indexPath.row]["name"] as! String)
            cell.cellRate.text = "\(result[indexPath.row]["rating"] as! Double)"
            cell.cellAddress.text = (result[indexPath.row]["address"] as! String)
            cell.cellImage.image = UIImage(data: imageData)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
}
