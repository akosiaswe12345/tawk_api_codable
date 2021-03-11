//
//  UserProfileViewController.swift
//  tawk.to exam
//
//  Created by Taison Digital on 3/10/21.
//

import UIKit
import SDWebImage
import CoreData

struct UserProfile : Codable {
    
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
    
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let twitter_username: String?
    let public_repos: Int?
    let public_gists: Int?
    let followers: Int?
    let following: Int?
    let created_at: String?
    let updated_at: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.id = try container.decode(Int.self, forKey: .id)
        self.node_id = try container.decode(String.self, forKey: .node_id)
        self.avatar_url = try container.decode(String.self, forKey: .avatar_url)
        self.gravatar_id = try container.decode(String.self, forKey: .gravatar_id)
        self.url = try container.decode(String.self, forKey: .url)
        self.html_url = try container.decode(String.self, forKey: .html_url)
        self.followers_url = try container.decode(String.self, forKey: .followers_url)
        self.following_url = try container.decode(String.self, forKey: .following_url)
        self.gists_url = try container.decode(String.self, forKey: .gists_url)
        self.starred_url = try container.decode(String.self, forKey: .starred_url)
        self.subscriptions_url = try container.decode(String.self, forKey: .subscriptions_url)
        self.organizations_url = try container.decode(String.self, forKey: .organizations_url)
        self.repos_url = try container.decode(String.self, forKey: .repos_url)
        self.events_url = try container.decode(String.self, forKey: .events_url)
        self.received_events_url = try container.decode(String.self, forKey: .received_events_url)
        self.type = try container.decode(String.self, forKey: .type)
        self.site_admin = try container.decode(Bool.self, forKey: .site_admin)
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.company = try container.decodeIfPresent(String.self, forKey: .company)
        self.blog = try container.decodeIfPresent(String.self, forKey: .blog)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.hireable = try container.decodeIfPresent(String.self, forKey: .hireable)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.twitter_username = try container.decodeIfPresent(String.self, forKey: .twitter_username)
        self.public_repos = try container.decodeIfPresent(Int.self, forKey: .public_repos)
        self.public_gists = try container.decodeIfPresent(Int.self, forKey: .public_gists)
        self.followers = try container.decodeIfPresent(Int.self, forKey: .followers)
        self.following = try container.decodeIfPresent(Int.self, forKey: .following)
        self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at)
        self.updated_at = try container.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}


class UserProfileViewController: UIViewController {

    @IBOutlet weak var userImage       : UIImageView!
    @IBOutlet weak var userLabel       : UILabel!
    @IBOutlet weak var companyLabel    : UILabel!
    @IBOutlet weak var blogLabel       : UILabel!
    @IBOutlet weak var followersLabel  : UILabel!
    @IBOutlet weak var followingLabel  : UILabel!
    @IBOutlet weak var noteTextView    : UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var values = [UserProfile]()
    
    
    var loginUser = ""
    var selectedIndex = 0
    
    
    var followersStr = 0
    var followingStr = 0
    var nameStr      = ""
    var companyStr = ""
    var blogStr = ""
    var avatarStr = ""
    var idStr = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        note()
        self.navigationItem.title = loginUser
        network()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayText()
    }
    
    func network(){
        if InternetConnectionManager.isConnectedToNetwork(){
            print("Connected")
            getUserData(user: loginUser)
        }else{
            print("Not Connected")
            
        }
    }
    
    func note(){
        noteTextView.delegate = self
        noteTextView.text = "Add notes ..."
        noteTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if noteTextView.text != "" {
            saveNote(id: Int64(idStr) , notes: noteTextView.text!, selectedIndex: selectedIndex )
        }else{
            presentDismissableAlertController(title: "Failed to save notes!", message: "Empty notes")
        }
    }
    
    func saveNote(id: Int64, notes: String, selectedIndex: Int){
        print("index D1", selectedIndex)
        let request : NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", "\(Int(id))")
        request.predicate = predicate
        request.fetchLimit = 1
        do{
            let count = try context.count(for: request)
            if(count == 0){
                print("no matches")
            } else {
                print("match found")
                let newValue = UserEntity(context: context)
                newValue.id = id
                newValue.notes = notes
                newValue.indexRow = Int64(selectedIndex)
                
              //  newValue.indexRow =
            }
            do {
                try context.save()
                print("Saved: \(id)")
            } catch {
                print("ERROR SAVING ENTITY")
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    

}

// MARK - API CALLs

extension UserProfileViewController {
    
    func getUserData(user: String) {
        print("GGWP1")
        
        guard let url = URL(string: "https://api.github.com/users/\(user)") else {
            return
        }
        
        print("URL NI USER", url)

        URLSession.shared.dataTask(with: url) { [self] (data, response, err) in

            guard let data = data else { return }

            do {
               let result  = try JSONDecoder().decode(UserProfile.self, from: data)
                print("RESULT123", result)
                
                followersStr = result.followers ?? 0
                followingStr = result.following ?? 0
                nameStr      = result.name ?? ""
                companyStr   = result.company ?? ""
                blogStr      = result.blog ?? ""
                avatarStr    = result.avatar_url ?? ""
                idStr        = result.id ?? 0
            } catch let jsonErr {
                print("ERROR JSON", jsonErr.localizedDescription)
              
            }
        }.resume()
    }
    
    func displayText(){
        
        if let url = URL(string: avatarStr){
            userImage.sd_setImage(with: url, completed: nil)
        }
        
        userLabel.text = "\(nameStr)"
        companyLabel.text = "\(companyStr)"
        blogLabel.text = "\(blogStr)"
        followersLabel.text = "\(followersStr)"
        followingLabel.text = "\(followingStr)"
        noteTextView.text =
    }
    
}

extension UserProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {

        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = ""
            noteTextView.textColor = UIColor.black
        }
    }
}
