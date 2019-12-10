//
//  ViewController.swift
//  ToDoList_iOS
//
//  Created by Ryota Akase on 2019/11/22.
//  Copyright © 2019 Ryota. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var jsonMap: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url: URL = URL(string: "http://52.203.253.84:8080/api/v1/tasks")!
        let task: URLSessionTask  = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                self.jsonMap = json.map { (jsonMap) -> [String: Any] in
                    return jsonMap as! [String: Any]
                }
                self.tableView.reloadData()
                print(self.jsonMap)
            }
            catch {
                // 例外処理を書く
                print(error)
            }
        })
        task.resume()
    }
    
    // セルの設定
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let taskNameLbl = cell.viewWithTag(2) as! UILabel
        let deadlineLbl = cell.viewWithTag(3) as! UILabel
        
        taskNameLbl.text = jsonMap[indexPath.row]["TaskName"] as? String
        deadlineLbl.text = jsonMap[indexPath.row]["Deadline"] as? String
        
        return cell
    }
    
    // セル数の設定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonMap.count
    }
    
    // セルの高さを設定
    func tableView(_ table: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}

