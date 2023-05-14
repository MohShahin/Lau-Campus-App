//
//  FeaturesViewController.swift
//  Lau_Campus_App
//
//  Created by Guest User on 4/30/23.
//

import UIKit
import CoreLocation

class FeaturesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    // Define the names and icons of the features
    private let features: [Feature] = [
        Feature(icon: UIImage(systemName: "map")!, name: "CampusMap"),
        Feature(icon: UIImage(systemName: "graduationcap.circle")!, name: "BlackBoard"),
        Feature(icon: UIImage(systemName: "calendar")!, name: "Calendar"),
        Feature(icon: UIImage(systemName: "book")!, name: "Study Notes"),
        Feature(icon: UIImage(systemName: "clock")!, name: "Events"),
        Feature(icon: UIImage(systemName: "arrowshape.turn.up.backward")!, name: "Feedback")
       ]
    
    // Define the colors for the cells
    let cellColors = [UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.00), // Red
                      UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.00), // Blue
                      UIColor(red: 0.96, green: 0.78, blue: 0.22, alpha: 1.00), // Yellow
                      UIColor(red: 0.23, green: 0.78, blue: 0.57, alpha: 1.00), // Green
                      UIColor(red: 0.61, green: 0.35, blue: 0.71, alpha: 1.00), // Purple
                      UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.00)] // Dark Grey
    
    // Define the sizes for the cells
    let cellSizes = [CGSize(width: 120, height: 120),
                     CGSize(width: 120, height: 120),
                     CGSize(width: 120, height: 120),
                     CGSize(width: 120, height: 120),
                     CGSize(width: 120, height: 120),
                     CGSize(width: 120, height: 120)]
    
    // Connect the Collection View outlet from the Storyboard
    @IBOutlet weak var featuresCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Collection View data source and delegate
        featuresCollectionView.dataSource = self
        featuresCollectionView.delegate = self
        
        // Register the CustomCollectionViewCell class
        featuresCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        featuresCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")

        
        // Set the Collection View background color
        featuresCollectionView.backgroundColor = UIColor.white
        
        // Set the tab bar title
        self.title = "Features"
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let feature = features[indexPath.item]
        cell.configure(with: feature)
        cell.backgroundColor = cellColors[indexPath.row % cellColors.count]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMap" {
            let newViewController = segue.destination as! ImageViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else if segue.identifier == "ToCalendar" {
            if let newViewController = segue.destination as? CalendarCollectionViewController {
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }

//-------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let featureName = features[indexPath.row]
        switch features[indexPath.item].name {
        case "CampusMap":
            // Create a MapViewController and push it onto the navigation stack
            self.performSegue(withIdentifier: "ToMap", sender: self)
         //::::::::::::::::::::::::::::::::
        case "BlackBoard":
            // Create a CalendarViewController and present it modally
            self.performSegue(withIdentifier: "ToBoard", sender: self)
            //::::::::::::::::::::::::::::::::
        case "Calendar":
            self.performSegue(withIdentifier: "ToCalendar", sender: self)
            //::::::::::::::::::::::::::::::::
        case "Study Notes":
            // Create a StudyNotesViewController and push it onto the navigation stack
            self.performSegue(withIdentifier: "ToNotes", sender: self)
            //::::::::::::::::::::::::::::::::
        case "Events":
            if let url = URL(string: "https://eventscal.lau.edu.lb") {
                UIApplication.shared.open(url)
            }
            //::::::::::::::::::::::::::::::::
        case "Feedback":
            // Create a FeedbackViewController and present it modally
            let feedbackForm = UIAlertController(title: "Feedback", message: "Please share your feedback with us", preferredStyle: .alert)
                    feedbackForm.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
                        // Handle feedback submission
                        let feedbackSubmitted = UIAlertController(title: "Thank You!", message: "Your feedback has been submitted.", preferredStyle: .alert)
                        feedbackSubmitted.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(feedbackSubmitted, animated: true, completion: nil)
                    }))
                    feedbackForm.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(feedbackForm, animated: true, completion: nil)
            
        default:
            break
        }
    }
}
//----------------------------------------------------------------
// MARK: - Collection View Flow Layout

extension FeaturesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.row % cellSizes.count]
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
//===============================================
// MARK: - Custom Collection View Cell

class CustomCollectionViewCell: UICollectionViewCell {
    var iconImageView: UIImageView!
    var nameLabel: UILabel!
        
        // Override init(frame:) method to create icon and name label
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // Customize the cell's appearance
            backgroundColor = .white
            layer.cornerRadius = 8
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.1
            
            // Create an image view for the icon
            iconImageView = UIImageView(image: UIImage(systemName: "square.fill"))
            iconImageView.tintColor = .white
            iconImageView.contentMode = .scaleAspectFit
            
            // Add the image view to the cell
            addSubview(iconImageView)
            
            // Set the icon's layout constraints
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            // Create a label for the feature name
            nameLabel = UILabel()
            nameLabel.textAlignment = .center
            nameLabel.textColor = .black
            nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            nameLabel.text = "Feature"
            
            // Add the label to the cell
            addSubview(nameLabel)
            
            // Set the label's layout constraints
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8).isActive = true
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Override prepareForReuse() method to reset cell contents
        override func prepareForReuse() {
            super.prepareForReuse()
            
            iconImageView.image = nil
            nameLabel.text = nil
        }
        
        // Update the cell's contents with the given feature
        
        func configure(with feature: Feature) {
            iconImageView.image = feature.icon
            nameLabel.text = feature.name
        }
    }
//==========================================================
class Feature {
    var icon: UIImage?
    var name: String?
    
    init(icon: UIImage?, name: String?) {
        self.icon = icon
        self.name = name
    }
}

