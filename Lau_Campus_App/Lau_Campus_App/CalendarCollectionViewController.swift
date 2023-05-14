//
//  CalendarViewController.swift
//  Lau_Campus_App
//
//  Created by Guest User on 5/3/23.


import UIKit
import CoreLocation

class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let daysInWeek = 7
    let startDate = Date() // Replace with start date of LAU semester
    let endDate = Date() // Replace with end date of LAU semester
    
    @IBOutlet var CalendarcollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a flow layout for the collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width / CGFloat(daysInWeek), height: view.bounds.height / 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        print("in")
        // Assign the flow layout to the collection view
        CalendarcollectionView.collectionViewLayout = layout
        
        CalendarcollectionView.dataSource = self
        CalendarcollectionView.delegate = self
        CalendarcollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "cell")
        CalendarcollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")

        
        // Add swipe gesture recognizers to enable scrolling through weeks
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        CalendarcollectionView.addGestureRecognizer(swipeLeft)
        CalendarcollectionView.addGestureRecognizer(swipeRight)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let daysInSemester = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        return Int(ceil(Double(daysInSemester) / Double(daysInWeek)))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            let weekday = Calendar.current.component(.weekday, from: startDate)
            return daysInWeek - (weekday - 1)
        } else if section == numberOfSections(in: collectionView) - 1 {
            let weekday = Calendar.current.component(.weekday, from: endDate)
            return weekday - 1
        } else {
            return daysInWeek
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        let section = indexPath.section
        let dayOfWeek = indexPath.item
        
        // Calculate the date for the cell
        let startDateOfWeek = Calendar.current.date(byAdding: .day, value: (section * daysInWeek) - section, to: startDate)!
        let date = Calendar.current.date(byAdding: .day, value: dayOfWeek, to: startDateOfWeek)!
        
        // Configure the cell
        cell.dateLabel.text = String(Calendar.current.component(.day, from: date))
        cell.backgroundColor = .red // Replace with custom color
        cell.layer.borderColor = UIColor.black.cgColor // Replace with custom color
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0 // Replace with custom value
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // This method is called when the user taps on a cell
        // You can use the `indexPath` parameter to determine which cell was tapped
        
        // Example implementation:
        let day = indexPath.section * daysInWeek + indexPath.row
        print("Day \(day) was selected")
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // User swiped left, scroll to next week
            let visibleItems = collectionView.indexPathsForVisibleItems
            if let firstItem = visibleItems.first {
                let section = firstItem.section
                let itemCount = collectionView.numberOfItems(inSection: section)
                if firstItem.row + 1 < itemCount {
                    let nextItem = IndexPath(row: firstItem.row + 1, section: section)
                    collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                } else if section + 1 < numberOfSections(in: collectionView) {
                    let nextItem = IndexPath(row: 0, section: section + 1)
                    collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
                }
            }
        } else if gesture.direction == .right {
            // User swiped right, scroll to previous week
            let visibleItems = collectionView.indexPathsForVisibleItems
            if let firstItem = visibleItems.first {
                let section = firstItem.section
                if firstItem.row > 0 {
                    let previousItem = IndexPath(row: firstItem.row - 1, section: section)
                    collectionView.scrollToItem(at: previousItem, at: .right, animated: true)
                } else if section > 0 {
                    let previousSection = section - 1
                    let itemCount = collectionView.numberOfItems(inSection: previousSection)
                    let previousItem = IndexPath(row: itemCount - 1, section: previousSection)
                    collectionView.scrollToItem(at: previousItem, at: .right, animated: true)
                }
            }
        }
    }
}

//=====================================================
class CalendarCell: UICollectionViewCell {
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 30),
            dateLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


