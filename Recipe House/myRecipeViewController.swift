//
//  myRecipeViewController.swift
//  Recipe House
//
//  Created by Ajay Vandra on 2/26/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PINRemoteImage

class myRecipeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var myrecipeArray = [HomeRecipe]()
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        if authtoken != "" {
        super.viewDidLoad()
            TableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
            searchBar.delegate = self
        }else if authtoken == ""{
            let alert = UIAlertController(title: "First you have to log in", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "log in", style: .default) { (alert) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myrecipeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! RecipeTableViewCell
        return cell
    }
    @IBAction func addButton(_ sender: UIButton) {
    }
    
    
}
