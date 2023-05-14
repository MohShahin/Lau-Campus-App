//
//  ViewController.swift
//  Lau_Campus_App
//
//  Created by Mohammad Shahin User on 4/16/23.
//

import UIKit

class LoginViewController: UIViewController {
    private var user_f = false
    private var pass_f = false
//---------------------------------------------------
    @IBOutlet weak var network: UIImageView!
    @IBOutlet weak var phone: UIImageView!
    @IBOutlet weak var Forgot: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passEye: UIImageView!
//---------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //::::::::::::::::::::::::::::::::::::::
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        network.addGestureRecognizer(tapGesture)
        network.isUserInteractionEnabled = true
        //::::::::::::::::::::::::::::::::::::::
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped2(gesture:)))
        phone.addGestureRecognizer(tapGesture2)
        phone.isUserInteractionEnabled = true
        //:::::::::::::::::::::::::::::::::::::
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(self.togglePasswordVisibility(gesture:)))
        passEye.addGestureRecognizer(tapGesture3)
        passEye.isUserInteractionEnabled = true
    }
//----------------------------------------------------------
    let Setting = Settings().self
    @IBAction func user_filled(_ sender: Any) {
        if ((Username.text?.contains("@lau.edu")) != nil){
            user_f = true
            ready()
        } else {
            print("Invalid input")
            user_f = false
            ready()
        }
    }
    //::::::::::::::::::::::::::::::::::::::::::
    @IBAction func password_filled(_ sender: Any) {
        if (password.text?.count ?? 0 >= 8){
            pass_f = true
            Forgot.isHidden = true
            ready()
        } else {
            ErorrLabel.text = "password must be more than 8"
            pass_f = false
            Forgot.isHidden = false
            ready()
        }
    }
    @objc func togglePasswordVisibility(gesture: UIGestureRecognizer) {
        password.isSecureTextEntry.toggle()
        let imageName = password.isSecureTextEntry ? "eye" : "eye.slash.fill"
        let image = UIImage(systemName: imageName)
        passEye.image = image
    }
//----------------------------------------------------
    @IBOutlet weak var ErorrLabel: UILabel!
    
    @IBAction func didPressLogin(sender: AnyObject) {
        // check if username and password are in the file
        if let fileUrl = Bundle.main.url(forResource: "users", withExtension: "txt") {
            do {
                let contents = try String(contentsOf: fileUrl)
                let lines = contents.split(separator: "\n")
                for line in lines {
                    let parts = line.split(separator: ",")
                    if parts.count > 2 {
                        let usernameFromFile = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let passwordFromFile = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        if usernameFromFile == Username.text && passwordFromFile == password.text {
                            // login successful
                            guard let username = Username.text,
                                          let password = password.text else { return }
                            
                            let settings = Settings()
                            settings.username = username
                            settings.password = password
                            //:::::::::::::::::::::::::
                            let board = BlackBoard()
                            board.username = username
                            board.password = password
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            return
                        }
                    }
                }
                // username and/or password not found in the file
                ErorrLabel.text = "Username and/or password not found"
                ErorrLabel.isHidden = false
            } catch {
                // failed to read file
                ErorrLabel.text = "Error reading file"
                ErorrLabel.isHidden = false

            }
        } else {
            // file not found
            ErorrLabel.text = "File not found"
            ErorrLabel.isHidden = false
        }
    }
//-----------------------------------------------------------
    @objc func imageTapped (gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            UIApplication.shared.openURL(URL(string: "https://www.lau.edu.lb")!)
        }
    }
    
    @objc func imageTapped2 (gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            UIApplication.shared.openURL(NSURL(string: "https://www.google.com/search?q=lebanese+american+university+phone+number&safe=active&client=safari&rls=en&sxsrf=APwXEdcRkFG6ywJD8MsOquk5lw_9r1E9Ww%3A1681671172040&ei=BEQ8ZLr6AdmlptQPx8mh0Aw&oq=lebanese+a+phone+number&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAxgCMgYIABAHEB4yBggAEAcQHjIGCAAQBxAeMggIABAIEAcQHjIICAAQCBAHEB4yBggAEAgQHjIGCAAQCBAeMggIABCKBRCGAzIICAAQigUQhgMyCAgAEIoFEIYDOgoIABBHENYEELADOgoIABCKBRCwAxBDOggIABCKBRCRAkoECEEYAFDaCFiPI2CAPGgCcAF4AIABgwGIAcwGkgEDOS4xmAEAoAEByAEKwAEB&sclient=gws-wiz-serp#")! as URL)
        }
    }
//-----------------------------------------------------------
    func ready () {
        if (pass_f && user_f){
            LoginButton.isHidden = false
            Forgot.isHidden = false
        }else{
            LoginButton.isHidden = true
            Forgot.isHidden = true
        }
    }
}
