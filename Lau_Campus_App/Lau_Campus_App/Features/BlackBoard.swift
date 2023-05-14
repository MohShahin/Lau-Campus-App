import UIKit
import WebKit

class BlackBoard: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var username: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        let eLearnUrl = URL(string: "https://iam.lau.edu.lb/isam/sps/auth")!
        let script = """
            document.getElementById("username").value='\(username ?? "")';
            document.getElementById("password").value='\(password ?? "")';
            document.getElementById("Log In").click();
        """
        
        webView.load(URLRequest(url: eLearnUrl))
        webView.evaluateJavaScript(script)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url?.absoluteString == "https://elearn.lau.edu.lb/d2l/home" {
            // Login successful, display the user's dashboard page
            print("Login successful!")
        } else {
            // Login failed, display an error message
            print("Login failed!")
        }
    }
}
