//
//  BaseTableViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.01.2021.
//

import UIKit

class BaseTableViewController<CellType: UITableViewCell>: UITableViewController {
    
    private let qiuckAddItemButton = QuickAddButton()
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attachQiuckAddItemButtonToSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeQiuckAddItemButtonFromSuperview()
    }
    
    // MARK: - Helper methods
    
    private func attachQiuckAddItemButtonToSuperview() {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { print("OOOPS");return }
        qiuckAddItemButton.frame = CGRect(x: window.frame.size.width * 0.82,
                                          y: window.frame.size.height * 0.82,
                                          width: qiuckAddItemButton.sideSize,
                                          height: qiuckAddItemButton.sideSize)
        
        qiuckAddItemButton.addTarget(self, action: #selector(qiuckAddItemButtonPressed), for: .touchUpInside)
        
        //        UIView.transition(with: qiuckAddItemButton,
        //                          duration: 0.5,
        //                          options: .curveEaseOut) {
        window.addSubview(self.qiuckAddItemButton)
        //        }
        
    }
    
    private func removeQiuckAddItemButtonFromSuperview() {
        //        UIView.transition(with: qiuckAddItemButton,
        //                          duration: 0.5,
        //                          options: .curveEaseOut) { [weak self] in
        qiuckAddItemButton.removeFromSuperview()
        //        }
    }
    
    private func configureTableView() {
        tableView.register(CellType.nib(), forCellReuseIdentifier: CellType.reuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    @objc private func qiuckAddItemButtonPressed() {
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.reuseIdentifier,
                                                       for: indexPath) as? CellType
        else { return UITableViewCell() }
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class MyTVC<CellType: ProjectTableViewCell>: BaseTableViewController<UITableViewCell> {
    func <#code#>
}
