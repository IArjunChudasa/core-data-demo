//
//  ViewController.swift
//  core data
//
//  Created by admin on 13/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    struct userdata {
        let name:String?
        let email:String?
        let mobile:String?
    }

    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtmobile: UITextField!
    var arrtbldata: [Dictionary<String, String>] = []

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        arrtbldata.removeAll()
        retrieveData()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnAddAction(_ sender: UIButton) {
        createData(name: txtname.text!, email: txtemail.text!, mobile: txtmobile.text!)
        clearTextfield()
        
    }
    func clearTextfield()
    {
        txtmobile.text = ""
        txtemail.text = ""
        txtname.text = ""
    }
       func retrieveData() {
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
    //        fetchRequest.fetchLimit = 1
    //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
    //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
    //
            do {
                arrtbldata.removeAll()
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    let name = data.value(forKey: "name") as! String
                    let email = data.value(forKey: "email") as! String
                    let mobile = data.value(forKey: "mobile") as! String
                    
                    print(data.value(forKey: "name") as! String)
                     print(data.value(forKey: "email") as! String)
                     print(data.value(forKey: "mobile") as! String)
                    let populatedDictionary = ["name": name, "email": email,"mobile": mobile]
                    arrtbldata.append(populatedDictionary)
                    

                }
                tableview.reloadData()
            } catch {
                
                print("Failed")
            }
        }
    func createData(name:String,email:String,mobile:String){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
      
            
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(name, forKeyPath: "name")
            user.setValue(email, forKey: "email")
            user.setValue(mobile, forKey: "mobile")
       

        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            retrieveData()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func deleteData(name:String){
           
           //As we know that container is set up in the AppDelegates so we need to refer that container.
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           //We need to create a context from this container
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
           fetchRequest.predicate = NSPredicate(format: "name = %@", name)
          
           do
           {
               let test = try managedContext.fetch(fetchRequest)
               
               let objectToDelete = test[0] as! NSManagedObject
               managedContext.delete(objectToDelete)
               
               do{
                   try managedContext.save()
                retrieveData()
               }
               catch
               {
                   print(error)
               }
               
           }
           catch
           {
               print(error)
           }
       }
    func updateData(oldname:String,name:String,email:String,mobile:String){
     
         //As we know that container is set up in the AppDelegates so we need to refer that container.
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
         
         //We need to create a context from this container
         let managedContext = appDelegate.persistentContainer.viewContext
         
         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
         fetchRequest.predicate = NSPredicate(format: "name = %@", oldname)
         do
         {
             let test = try managedContext.fetch(fetchRequest)
    
                 let objectUpdate = test[0] as! NSManagedObject
                 objectUpdate.setValue(name, forKey: "name")
                 objectUpdate.setValue(email, forKey: "email")
                 objectUpdate.setValue(mobile, forKey: "mobile")
                 do{
                     try managedContext.save()
                    retrieveData()
                 }
                 catch
                 {
                     print(error)
                 }
             }
         catch
         {
             print(error)
         }
    
     }
    func openPopup(oldname:String)
    {
        let alert = UIAlertController(title: "Alert", message: "Fill the details", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textFieldname) in
            textFieldname.placeholder = "Enter Name"
        }
        alert.addTextField { (textFieldemail) in
            textFieldemail.placeholder = "Enter Email"
        }
        alert.addTextField { (textFieldmobile) in
            textFieldmobile.placeholder = "Enter Mobile"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textFieldname = alert?.textFields![0]
            let textFieldemail = alert?.textFields![1]
            let textFieldmobile = alert?.textFields![2]// Force unwrapping because we know it exists.
            print("name: \(String(describing: textFieldname!.text))")
            print("email: \(String(describing: textFieldemail!.text))")
            print("mobile: \(String(describing: textFieldmobile!.text))")
            self.updateData(oldname: oldname, name: (textFieldname?.text!)!, email: (textFieldemail?.text!)!, mobile: (textFieldmobile?.text!)!)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtbldata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = (self.tableview.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell?)!
        cell.lblname.text = arrtbldata[indexPath.row]["name"]
        cell.lblemail.text = arrtbldata[indexPath.row]["email"]
        cell.lblmobile.text = arrtbldata[indexPath.row]["mobile"]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

        let closeAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("CloseAction ...")
            let str = self.arrtbldata[indexPath.row]["name"]
            self.openPopup(oldname: str!)
            success(true)
        })
        closeAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let name = arrtbldata[indexPath.row]["name"]
            deleteData(name: name!)
            // handle delete (by removing the data from your array and updating the tableview)
        }
        if (editingStyle == .insert) {
                   // handle delete (by removing the data from your array and updating the tableview)
               }
    }
}

