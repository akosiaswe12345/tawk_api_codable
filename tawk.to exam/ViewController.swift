//
//  ViewController.swift
//  tawk.to exam
//
//  Created by Taison Digital on 3/8/21.
//

import UIKit
import SDWebImage
import CoreData
import SVProgressHUD

struct User : Codable {
    
    let login: String?
    let id: Int?
    let node_id: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url: String?
    let html_url: String?
    let followers_url: String?
    let following_url: String?
    let gists_url: String?
    let starred_url: String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url: String?
    let events_url: String?
    let received_events_url: String?
    let type: String?
    let site_admin: Bool?
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.login = try container.decode(String.self, forKey: .login)
//        self.id = try container.decode(Int.self, forKey: .id)
//        self.node_id = try container.decode(String.self, forKey: .node_id)
//        self.avatar_url = try container.decode(String.self, forKey: .avatar_url)
//        self.gravatar_id = try container.decode(String.self, forKey: .gravatar_id)
//        self.url = try container.decode(String.self, forKey: .url)
//        self.html_url = try container.decode(String.self, forKey: .html_url)
//        self.followers_url = try container.decode(String.self, forKey: .followers_url)
//        self.following_url = try container.decode(String.self, forKey: .following_url)
//        self.gists_url = try container.decode(String.self, forKey: .gists_url)
//        self.starred_url = try container.decode(String.self, forKey: .starred_url)
//        self.subscriptions_url = try container.decode(String.self, forKey: .subscriptions_url)
//        self.organizations_url = try container.decode(String.self, forKey: .organizations_url)
//        self.repos_url = try container.decode(String.self, forKey: .repos_url)
//        self.events_url = try container.decode(String.self, forKey: .events_url)
//        self.received_events_url = try container.decode(String.self, forKey: .received_events_url)
//        self.type = try container.decode(String.self, forKey: .type)
//        self.site_admin = try container.decode(Bool.self, forKey: .site_admin)
//    }
    
}

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var searchBar = UISearchBar(frame: .zero)
    
    var values = [User]()
    var didHaveNextPage = true
    var currentPage = 0
    var selectedIndex = 0
    
    var loginUser = [String]()
    var id = [Int]()
    var node_id = [String]()
    var avatar_url = [String]()
    var gravatar_id = [String]()
    var url = [String]()
    var html_url = [String]()
    var followers_url =  [String]()
    var following_url = [String]()
    var gists_url = [String]()
    var starred_url = [String]()
    var subscriptions_url = [String]()
    var organizations_url = [String]()
    var repos_url = [String]()
    var events_url = [String]()
    var received_events_url = [String]()
    var type =  [String]()
    var site_admin = [Bool]()
    var notes = [String]()
    var notes_id = [Int]()
    
    var people = [UserEntity]()
    var notesArray = [UserEntity]()
    var contacts: [UserEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSelf()
        setUpSearchBar()
        getUserId()
        tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            loader()
            self?.getUserData()
            self?.getUserId()
           
        }
        
        self.searchBar.text = ""

        if InternetConnectionManager.isConnectedToNetwork(){
            print("Connected")
            removeAll()
            tableView.reloadData()
        }else{
            print("Not Connected")
            removeAll()
            tableView.reloadData()
            self.getFetch()
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profile = segue.destination as? UserProfileViewController  {
            profile.loginUser = loginUser[selectedIndex]
            profile.selectedIndex = selectedIndex + 1
            //colorWheelController.selectedSpeakerName = selectedSpeakerName
        }
    }

    
    func tableViewSelf(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpSearchBar() {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.searchBarStyle = .prominent
        searchBar.tintColor = UIColor.black
        navigationItem.titleView = searchBar
    }
    
    func getUserData() {
        print("TEST1")
        
        guard let url = URL(string: "https://api.github.com/users?since=0") else {
            return
        }

        URLSession.shared.dataTask(with: url) { [self] (data, response, err) in

            guard let data = data else { return }

            do {
               let result  = try JSONDecoder().decode([User].self, from: data)
                self.values = result
                
                SVProgressHUD.dismiss()
                
                for i in 0..<self.values.count {
                    
                    if InternetConnectionManager.isConnectedToNetwork(){
                        self.loginUser.append(self.values[i].login ?? "")
                        self.id.append(self.values[i].id ?? 0)
                        self.node_id.append(self.values[i].node_id ?? "")
                        self.avatar_url.append(self.values[i].avatar_url ?? "")
                        self.gravatar_id.append(self.values[i].gravatar_id ?? "")
                        self.url.append(self.values[i].url ?? "")
                        self.html_url.append(self.values[i].html_url ?? "")
                        self.followers_url.append(self.values[i].followers_url ?? "")
                        self.following_url.append(self.values[i].following_url ?? "")
                        self.gists_url.append(self.values[i].gists_url ?? "")
                        self.starred_url.append(self.values[i].starred_url ?? "")
                        self.subscriptions_url.append(self.values[i].subscriptions_url ?? "")
                        self.organizations_url.append(self.values[i].organizations_url ?? "")
                        self.repos_url.append(self.values[i].repos_url ?? "")
                        self.events_url.append(self.values[i].events_url ?? "")
                        self.received_events_url.append(self.values[i].received_events_url ?? "")
                        self.type.append(self.values[i].type ?? "")
                        self.site_admin.append(self.values[i].site_admin ?? false)
                    }else{
                     
                    }
                    
                    
                    self.saveIfNotNull(login: self.values[i].login ?? "", id: Int64(self.values[i].id ?? 0), node_id: self.values[i].node_id ?? "", avatar_url: self.values[i].avatar_url ?? "", gravatar_id: self.values[i].gravatar_id ?? "", url: self.values[i].url ?? "", html_url: self.values[i].html_url ?? "", followers_url: self.values[i].followers_url ?? "", following_url: self.values[i].following_url ?? "", gists_url: self.values[i].gists_url ?? "", starred_url: self.values[i].starred_url ?? "", subscriptions_url: self.values[i].subscriptions_url ?? "", organizations_url: self.values[i].organizations_url ?? "", repos_url: self.values[i].repos_url ?? "", events_url: self.values[i].events_url ?? "", received_events_url: self.values[i].received_events_url ?? "", type: self.values[i].type ?? "", site_admin: self.values[i].site_admin ?? false)
                    
                    
                }
             
                self.didHaveNextPage = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            } catch let jsonErr {
                SVProgressHUD.dismiss()
                print("ERROR JSON", jsonErr.localizedDescription)
              
            }
        }.resume()
    }
    
    func getUserDataPagination(currentPage: Int) {
        print("TEST2")
        
        guard let url = URL(string: "https://api.github.com/users?since=\(currentPage)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in

            guard let data = data else { return }

            do {
               let result  = try JSONDecoder().decode([User].self, from: data)
                self.values = result
                
                SVProgressHUD.dismiss()
                
                for i in 0..<self.values.count {
                    if InternetConnectionManager.isConnectedToNetwork(){
                        self.loginUser.append(self.values[i].login ?? "")
                        self.id.append(self.values[i].id ?? 0)
                        self.node_id.append(self.values[i].node_id ?? "")
                        self.avatar_url.append(self.values[i].avatar_url ?? "")
                        self.gravatar_id.append(self.values[i].gravatar_id ?? "")
                        self.url.append(self.values[i].url ?? "")
                        self.html_url.append(self.values[i].html_url ?? "")
                        self.followers_url.append(self.values[i].followers_url ?? "")
                        self.following_url.append(self.values[i].following_url ?? "")
                        self.gists_url.append(self.values[i].gists_url ?? "")
                        self.starred_url.append(self.values[i].starred_url ?? "")
                        self.subscriptions_url.append(self.values[i].subscriptions_url ?? "")
                        self.organizations_url.append(self.values[i].organizations_url ?? "")
                        self.repos_url.append(self.values[i].repos_url ?? "")
                        self.events_url.append(self.values[i].events_url ?? "")
                        self.received_events_url.append(self.values[i].received_events_url ?? "")
                        self.type.append(self.values[i].type ?? "")
                        self.site_admin.append(self.values[i].site_admin ?? false)
                    }else{
                     
                    }
                    
                    self.saveIfNotNull(login: self.values[i].login ?? "", id: Int64(self.values[i].id ?? 0), node_id: self.values[i].node_id ?? "", avatar_url: self.values[i].avatar_url ?? "", gravatar_id: self.values[i].gravatar_id ?? "", url: self.values[i].url ?? "", html_url: self.values[i].html_url ?? "", followers_url: self.values[i].followers_url ?? "", following_url: self.values[i].following_url ?? "", gists_url: self.values[i].gists_url ?? "", starred_url: self.values[i].starred_url ?? "", subscriptions_url: self.values[i].subscriptions_url ?? "", organizations_url: self.values[i].organizations_url ?? "", repos_url: self.values[i].repos_url ?? "", events_url: self.values[i].events_url ?? "", received_events_url: self.values[i].received_events_url ?? "", type: self.values[i].type ?? "", site_admin: self.values[i].site_admin ?? false)
                    
                   
                }
                
                self.didHaveNextPage = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            } catch let jsonErr {
                SVProgressHUD.dismiss()
                print("ERROR JSON", jsonErr.localizedDescription)
            }
        }.resume()
    }


}

 // MARK - for entity

extension ViewController {
    
    func saveIfNotNull(login: String, id: Int64, node_id: String, avatar_url: String, gravatar_id: String,
              url: String, html_url: String, followers_url: String, following_url: String, gists_url: String,
              starred_url: String, subscriptions_url: String, organizations_url: String, repos_url: String, events_url: String,
              received_events_url: String, type: String, site_admin: Bool) {
        
        print("CHECK 1")
        
        let request : NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        print("ID DITO", id)
        let predicate = NSPredicate(format: "id = %@", "\(Int(id))")
        request.predicate = predicate
        request.fetchLimit = 1
        do{
            let count = try context.count(for: request)
            //instead of managedContext use context,
            // where let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            if(count == 0){
                print("no matches")
                let newValue = UserEntity(context: context)
                newValue.login = login
                newValue.id = id
                newValue.node_id = node_id
                newValue.avatar_url = avatar_url
                newValue.gravatar_id = gravatar_id
                newValue.url = url
                newValue.html_url = html_url
                newValue.followers_url = followers_url
                newValue.following_url = following_url
                newValue.gists_url = gists_url
                newValue.starred_url = starred_url
                newValue.subscriptions_url = subscriptions_url
                newValue.organizations_url = organizations_url
                newValue.repos_url = repos_url
                newValue.events_url = events_url
                newValue.received_events_url = received_events_url
                newValue.type = type
                newValue.site_admin = site_admin
                newValue.notes = ""
                newValue.indexRow = 0
                    
                do {
                    try context.save()
                    print("Saved: \(login)")
                } catch {
                    print("ERROR SAVING ENTITY")
                }
            }
            else{
                print("match found")
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func getFetch(){
        do {
            people = try context.fetch(UserEntity.fetchRequest())
            print("COUNTING get Fetch", people.count)
            for i in 0..<people.count {
                self.loginUser.append(self.people[i].login ?? "")
                self.id.append(Int(self.people[i].id ))
                self.node_id.append(self.people[i].node_id ?? "")
                self.avatar_url.append(self.people[i].avatar_url ?? "")
                self.gravatar_id.append(self.people[i].gravatar_id ?? "")
                self.url.append(self.people[i].url ?? "")
                self.html_url.append(self.people[i].html_url ?? "")
                self.followers_url.append(self.people[i].followers_url ?? "")
                self.following_url.append(self.people[i].following_url ?? "")
                self.gists_url.append(self.people[i].gists_url ?? "")
                self.starred_url.append(self.people[i].starred_url ?? "")
                self.subscriptions_url.append(self.people[i].subscriptions_url ?? "")
                self.organizations_url.append(self.people[i].organizations_url ?? "")
                self.repos_url.append(self.people[i].repos_url ?? "")
                self.events_url.append(self.people[i].events_url ?? "")
                self.received_events_url.append(self.people[i].received_events_url ?? "")
                self.type.append(self.people[i].type ?? "")
                self.site_admin.append(self.people[i].site_admin)
               // self.notes.append(self.people[i].notes ?? "")
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func getUserId(){
        
        do {
            notesArray = try context.fetch(UserEntity.fetchRequest())
            print("COUNTING get Fetch", notesArray.count)
            for i in 0..<notesArray.count {
                print("NOTED DADA", notesArray[i].notes)
                if self.notesArray[i].notes != "" {
                    self.notes_id.append(Int(self.notesArray[i].indexRow ))
//                    self.notes.append(self.notesArray[i].notes ?? "")

                    print("NOTES id", Int(self.notesArray[i].id ), "notes", self.notesArray[i].notes ?? "" )

                }


            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
        
        
       
    }
    
    func removeAll() {
        loginUser.removeAll()
        id.removeAll()
        node_id.removeAll()
        avatar_url.removeAll()
        gravatar_id.removeAll()
        url.removeAll()
        html_url.removeAll()
        followers_url.removeAll()
        following_url.removeAll()
        gists_url.removeAll()
        starred_url.removeAll()
        subscriptions_url.removeAll()
        organizations_url.removeAll()
        repos_url.removeAll()
        events_url.removeAll()
        received_events_url.removeAll()
        type.removeAll()
        site_admin.removeAll()
    }

}

 // MARK: - tableview

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loginUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as? userListTableViewCell {
            setUpCell(cell: cell, indexPath: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if self.didHaveNextPage {
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                currentPage+=1
                print("CURRENT PAGE ITO", currentPage)
                self.getUserDataPagination(currentPage: currentPage)                
            }
        } else {
            self.tableView.tableFooterView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("Selected index", selectedIndex)
        performSegue(withIdentifier: "profile", sender: nil)
    }
    
    func setUpCell(cell: userListTableViewCell, indexPath: IndexPath){
        cell.usernameLabel.text = loginUser[indexPath.row]
     //   cell.userImage.image = UIImage(url: URL(string: values[indexPath.row].avatar_url ?? ""))
        if let url = URL(string: avatar_url[indexPath.row]){
            cell.userImage.sd_setImage(with: url, completed: nil)
        }
        
//        if InternetConnectionManager.isConnectedToNetwork(){
//            print("Connected")
//
//        }else{
//            print("Not Connected")
//            if self.notes[indexPath.row].contains("") {
//                cell.noteImage.isHidden = true
//            }else{
//                cell.noteImage.isHidden = false
//            }
//        }
        
      
        
        
//        for i in 0..<self.notes_id.count {
//            print("JAJAJAJ", notes_id[i])
//            if indexPath.row ==   notes_id[i]-1 {
//                cell.noteImage.isHidden = false
//            }else {
//                cell.noteImage.isHidden = true
//            }
//
//        }
    }

    
    
}

 // MARK : UI SEARCH BAR DELEGATE

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        if searchBar == self.searchBar {
            if searchBar.returnKeyType == .done {

            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.tableVIew.reloadData()
//        self.reload()
        
        // hide clear button
        guard let firstSubview = searchBar.subviews.first else { return }
        firstSubview.subviews.forEach { ($0 as? UITextField)?.clearButtonMode = .never }
        searchBar.setShowsCancelButton(true, animated: true)
//        tableVIew.isHidden = true
//        emptyStateView.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
//        self.tableVIew.reloadData()
//        self.reload()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
//        self.tableVIew.isHidden = false
//        self.tableVIew.reloadData()
//        self.reload()
        
        let typeCasteToStringFirst = searchBar.text as NSString?
        let newString = typeCasteToStringFirst?.replacingCharacters(in: range, with: text)
        let finalSearchString = newString ?? ""
        
        if !finalSearchString.isEmpty {
            self.loadSearchFriendList(withKeyword: finalSearchString.lowercased())
        }
        
        
//        self.currentSearchKey = finalSearchString.lowercased()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
//        self.emptyStateView.isHidden = true
//        self.tableVIew.isHidden = true
//        self.tableVIew.reloadData()
//        self.reload()
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
    }
    
    func loadSearchFriendList(withKeyword: String){
        removeAll()
        var predicate: NSPredicate = NSPredicate()
                predicate = NSPredicate(format: "login contains[c] '\(withKeyword)'")
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"UserEntity")
                fetchRequest.predicate = predicate
                do {
                    contacts = try managedObjectContext.fetch(fetchRequest) as! [UserEntity]
                    for i in 0..<contacts.count {
                        print("SEARCHING...", contacts[i].login ?? "")
                        
                        self.loginUser.append(self.contacts[i].login ?? "")
                        self.id.append(Int(self.contacts[i].id ))
                        self.node_id.append(self.contacts[i].node_id ?? "")
                        self.avatar_url.append(self.contacts[i].avatar_url ?? "")
                        self.gravatar_id.append(self.contacts[i].gravatar_id ?? "")
                        self.url.append(self.contacts[i].url ?? "")
                        self.html_url.append(self.contacts[i].html_url ?? "")
                        self.followers_url.append(self.contacts[i].followers_url ?? "")
                        self.following_url.append(self.contacts[i].following_url ?? "")
                        self.gists_url.append(self.contacts[i].gists_url ?? "")
                        self.starred_url.append(self.contacts[i].starred_url ?? "")
                        self.subscriptions_url.append(self.contacts[i].subscriptions_url ?? "")
                        self.organizations_url.append(self.contacts[i].organizations_url ?? "")
                        self.repos_url.append(self.contacts[i].repos_url ?? "")
                        self.events_url.append(self.contacts[i].events_url ?? "")
                        self.received_events_url.append(self.contacts[i].received_events_url ?? "")
                        self.type.append(self.contacts[i].type ?? "")
                        self.site_admin.append(self.contacts[i].site_admin)
                    }
                    
                } catch let error as NSError {
                    print("Could not fetch. \(error)")
                }
        
        tableView.reloadData()
    }
}


 // MARK:

class userListTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel  : UILabel!
    @IBOutlet weak var detailsLabel   : UILabel!
    
    @IBOutlet weak var userImage      : UIImageView!
    @IBOutlet weak var noteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}

extension UIImageView {

    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}

