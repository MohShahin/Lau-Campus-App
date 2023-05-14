//
//  SettingsViewController.swift
//  Lau_Campus_App
//
//  Created by Guest User on 4/17/23.
//

import UIKit
import WebKit

class Settings: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var advisorLabel: UILabel!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var dormsLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var cgpaLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var username: String?
    var password: String?
    @IBOutlet weak var webView: WKWebView!

    @IBOutlet weak var ImageChanger: UIImageView!
    //---------------------------------------------
    
    @IBAction func PortalTapped(_ sender: Any) {
        if let url = URL(string: "https://myportal.lau.edu.lb") {
            UIApplication.shared.open(url)
        }
    }
    //-----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://myportal.lau.edu.lb")!
        let request = URLRequest(url: url)
        webView.load(request)

        
        // Load user info from file
        if let fileUrl = Bundle.main.url(forResource: "users", withExtension: "txt") {
            do {
                let contents = try String(contentsOf: fileUrl)
                let lines = contents.split(separator: "\n")
                for line in lines {
                    let parts = line.split(separator: ",")
                    if parts.count > 2 {
                        if let username = username, parts[1] == username {
                            studentNameLabel.text = String(parts[2]).trimmingCharacters(in: .whitespacesAndNewlines)
                            idLabel.text = String(parts[3]).trimmingCharacters(in: .whitespacesAndNewlines)
                            majorLabel.text = String(parts[4])
                            minorLabel.text = String(parts[5])
                            advisorLabel.text = String(parts[6])
                            campusLabel.text = String(parts[7])
                            dormsLabel.text = String(parts[8])
                            roomLabel.text = String(parts[9])
                            cgpaLabel.text = String(parts[10])
                            break
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        
        // Load profile picture from file
        if let username = username {
            let imageURL = getDocumentsDirectory().appendingPathComponent("\(username)_profile.png")
            if let imageData = try? Data(contentsOf: imageURL) {
                profileImageView.image = UIImage(data: imageData)
            }
        }
        
        // Add tap gesture to profile picture
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(self.changeProfilePicture(gesture:)))
        ImageChanger.addGestureRecognizer(tapGesture)
        ImageChanger.isUserInteractionEnabled = true
        
    }
    //-------------------------------------------------------------
    // MARK: - Actions
    
    @IBOutlet weak var RestButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    var pressed = false
    @IBAction func menuButtonTapped(_ sender: Any) {
        RestButton.isHidden = pressed
        LogOutButton.isHidden = pressed
        pressed = !pressed
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        // Switch to login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    @IBAction func ResetButtonTapped(_ sender: Any) {
        // Show alert to enter new password
        let alertController = UIAlertController(title: "Reset Password", message: "Enter your new password", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        })
        let resetAction = UIAlertAction(title: "Reset", style: .default, handler: { action in
            if let textField = alertController.textFields?.first, let newPassword = textField.text {
                // Save new password to file
                if let fileUrl = Bundle.main.url(forResource: "users", withExtension: "txt") {
                    do {
                        let contents = try String(contentsOf: fileUrl)
                        let lines = contents.split(separator: "\n")
                        var output = ""
                        for line in lines {
                            let parts = line.split(separator: ",")
                            if parts.count > 2 {
                                if let username = self.username, parts[1] == username {
                                    let encryptedPassword = self.encryptPassword(newPassword)
                                    output += "\(parts[0]),\(parts[1]),\(encryptedPassword),\(parts[3]),\(parts[4]),\(parts[5]),\(parts[6]),\(parts[7]),\(parts[8]),\(parts[9]),\(parts[10])\n"
                                } else {
                                    output += "\(line)\n"
                                }
                            }
                        }
                        try output.write(to: fileUrl, atomically: true, encoding: .utf8)
                        
                        // Show success message
                        let successAlert = UIAlertController(title: "Success", message: "Password reset successful!", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(successAlert, animated: true)
                    } catch {
                        print(error)
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    //--------------------------------------------
    func encryptPassword(_ password: String) -> String {
        // Simple encryption function
        return String(password.reversed())
    }
    //---------------------------------------------------------
    // MARK: Image Functions

    @objc func changeProfilePicture(gesture: UIGestureRecognizer) {
        // Present a UIImagePickerController to the user to choose a new profile picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
            // Save the image to the user's documents directory for future use
            if let username = username {
                let imageURL = getDocumentsDirectory().appendingPathComponent("\(username)_profile.png")
                if let data = image.pngData() {
                    do {
                        try data.write(to: imageURL)
                    } catch {
                        print("Failed to save profile picture: \(error.localizedDescription)")
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

