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

class myRecipeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    var myrecipeArray = [HomeRecipe]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
