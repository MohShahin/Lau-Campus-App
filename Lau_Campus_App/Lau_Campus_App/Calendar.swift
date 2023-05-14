import UIKit

private let reuseIdentifier = "Cell"

class Calendar: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let daysInWeek = 7
    let startDate = Date() // Replace with start date of LAU semester
    let endDate = Date() // Replace with end date of LAU semester
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Add swipe gesture recognizers to enable scrolling through weeks
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        collectionView.addGestureRecognizer(swipeLeft)
        collectionView.addGestureRecognizer(swipeRight)
    }

}

extension Calendar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let daysInSemester = Foundation.Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        return Int(ceil(Double(daysInSemester) / Double(daysInWeek)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            let weekday = Foundation.Calendar.current.component(.weekday, from: startDate)
            return daysInWeek - (weekday - 1)
        } else if section == numberOfSections(in: collectionView) - 1 {
            let weekday = Foundation.Calendar.current.component(.weekday, from: endDate)
            return weekday - 1
        } else {
            return daysInWeek
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarCell2
        
        let section = indexPath.section
        let dayOfWeek = indexPath.item
        
        // Calculate the date for the cell
        let startDateOfWeek = Foundation.Calendar.current.date(byAdding: .day, value: (section * daysInWeek) - section, to: startDate)!
        let date = Foundation.Calendar.current.date(byAdding: .day, value: dayOfWeek, to: startDateOfWeek)!
        
        // Configure the cell
        cell.dateLabel.text = String(Foundation.Calendar.current.component(.day, from: date))
        cell.backgroundColor = .white // Replace with custom color
        cell.layer.borderColor = UIColor.black.cgColor // Replace with custom color
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0 // Replace with custom value
        
        return cell
    }
}
       


extension Calendar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // This method is called when the user taps on a cell
        // You can use the `indexPath` parameter to determine which cell was tapped
        
        // Example implementation:
        let day = indexPath.section * daysInWeek + indexPath.row - (daysInWeek - Foundation.Calendar.current.component(.weekday, from: startDate))
        let date = Foundation.Calendar.current.date(byAdding: .day, value: day, to: startDate)!
        print("User tapped on date: \(date)")
    }
    
    // Handle swipe gestures to scroll through weeks
    @objc func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        guard let collectionView = self.collectionView else { return }
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted()
        guard !visibleItems.isEmpty else { return }
        
        let firstVisibleItem = visibleItems[0]
        let lastVisibleItem = visibleItems[visibleItems.count - 1]
        let numberOfSections = self.numberOfSections(in: collectionView)
        
        switch gesture.direction {
        case .left:
            // Swipe left to move to next week
            if lastVisibleItem.section < numberOfSections - 1 {
                let nextIndexPath = IndexPath(item: firstVisibleItem.item, section: firstVisibleItem.section + 1)
                collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
            }
        case .right:
            // Swipe right to move to previous week
            if firstVisibleItem.section > 0 {
                let previousIndexPath = IndexPath(item: firstVisibleItem.item, section: firstVisibleItem.section - 1)
                collectionView.scrollToItem(at: previousIndexPath, at: .left, animated: true)
            }
            
        default:
            break
        }
    }
    //---------------------------------------
    // Customize cell size to fit screen width and maintain aspect ratio
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(daysInWeek)
        let height = width * 1.5 // Adjust this value as desired
        return CGSize(width: width, height: height)
    }
}
//==================================================================
class CalendarCell2: UICollectionViewCell {
    let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        addSubview(dayOfWeekLabel)
        addSubview(dateLabel)
        
        // Set constraints for dayOfWeekLabel
        dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOfWeekLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dayOfWeekLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dayOfWeekLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dayOfWeekLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dayOfWeekLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dayOfWeekLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dayOfWeekLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true

        
        // Set constraints for dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: dayOfWeekLabel.bottomAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
