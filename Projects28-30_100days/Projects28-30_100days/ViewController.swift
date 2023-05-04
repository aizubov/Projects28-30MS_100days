//
//  ViewController.swift
//  Projects28-30_100days
//
//  Created by user228564 on 5/1/23.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var dataDict: [String: String] = [:]
    var dataArray: [String]?
    var cellCount: Int = 0
    var score: Int = 0
    
    // The data for the game
    //var dataDict = ["The US": "Washington", "Canada": "Ottawa", "Mexico": "Mexico City", "Brazil": "Brasília", "Argentina": "Buenos Aires", "Chile": "Santiago", "Australia": "Canberra", "New Zealand": "Wellington", "Japan": "Tokyo"]
    
    // The collection view
    private var collectionView: UICollectionView!
    var firstSelectedCard: CardCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = dataDict.flatMap { (key, value) in
            return [key, value]
        }
        dataArray?.shuffle()
        
        title = "Score: \(score)"
        
        // Set up the collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Create the collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        collectionView.backgroundColor = .white
        
        // Add the collection view to the view hierarchy
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let passDictionaryBarButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))
        navigationItem.rightBarButtonItem = passDictionaryBarButton
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataDict.count * 2
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        
        
        //print(dataArray)
        
        // Get the index of the corresponding country/capital pair
        let dataAtIndex = dataArray?[indexPath.item]
        
        cell.configure(withItem: dataAtIndex ?? "Placeholder")
        return cell
    }
        
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.isFlipped {
            return
        }
        
        cell.flip()
        
        if firstSelectedCard == nil {
            firstSelectedCard = cell
        } else {
            if dataDict.contains(where: { $0.key == firstSelectedCard!.cardValue && $0.value == cell.cardValue || $0.key == cell.cardValue && $0.value == firstSelectedCard!.cardValue}) {
                // Matched
                firstSelectedCard = nil
                cell.isUserInteractionEnabled = false
                firstSelectedCard?.isUserInteractionEnabled = false
                
                cellCount += 1
            } else {
                // Not matched
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.firstSelectedCard?.flipBack()
                    cell.flipBack()
                    self.firstSelectedCard = nil
                }
            }
        }
        if cellCount == dataDict.count {
            score += 1
            title = "Score: \(score)"
        }
    }
    
    @objc func newGame() {
        for cell in collectionView.visibleCells {
            if let myCell = cell as? CardCell {
                myCell.flipBack()
                myCell.isUserInteractionEnabled = true
                
            }
        }
        cellCount = 0
        dataArray?.shuffle()
        collectionView.reloadData()
    }
}
