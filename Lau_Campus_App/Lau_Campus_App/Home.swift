import UIKit

struct RSSItem {
    var title: String
    var pubDate: Date
    var description: String
    var link: URL
}

class RSSParser: NSObject, XMLParserDelegate {
    
    private var rssItems: [RSSItem] = []
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentPubDate: Date = Date()
    private var currentDescription: String = ""
    private var currentLink: URL?
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: URL, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentPubDate = Date()
            currentDescription = ""
            currentLink = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "pubDate":
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
            if let date = dateFormatter.date(from: string) {
                currentPubDate = date
            }
        case "description":
            currentDescription += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "link":
            if let url = URL(string: string.trimmingCharacters(in: .whitespacesAndNewlines)) {
                currentLink = url
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, pubDate: currentPubDate, description: currentDescription, link: currentLink ?? URL(string: "https://www.lau.edu.lb")!)
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
}

class Home: UITableViewController {
    
    @IBOutlet var NewsTable: UITableView!
    var rssItems: [RSSItem] = []
    
    init() {
        super.init(style: .plain)
        self.tableView = UITableView(frame: .zero, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rssURL = URL(string: "https://news.lau.edu.lb/rss.xml")!
        let rssParser = RSSParser()
        rssParser.parseFeed(url: rssURL) { (rssItems) in
            self.rssItems = rssItems
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = rssItems[indexPath.row].title
        return cell
    }
}
