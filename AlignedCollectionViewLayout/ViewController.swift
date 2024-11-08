//
//  ViewController.swift
//  AlignedCollectionViewLayout
//
//  Created by Sofya Avtsinova on 08.11.2024.
//

import UIKit

class ViewController: UIViewController {
    private let collectionElements: [[Size]] = [
        [Size.small, Size.small, Size.small, Size.small, Size.small],
        [Size.normal, Size.normal, Size.small],
        [Size.small, Size.small, Size.normal]
    ]
    
    private lazy var collectionData: Data = Data(alignment: .right, elements: collectionElements)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(AlignedCollectionViewCell.self, forCellWithReuseIdentifier: "AlignedCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        collectionView.reloadData()
        showData(data: collectionData)
    }
}

private extension ViewController {
    func showData(data: Data) {
        data.elements.forEach { value in
            if value.isEmpty {
                fatalError()
            }

            if value.reduce(0.0, { $0 + $1.rawValue }) > 1 {
                fatalError()
            }
        }
        
        showUI(data: data)
    }

    func showUI(data: Data) {
        let layout = AlignedCollectionViewLayout(alignment: data.alignment, items: data.elements)
        collectionView.collectionViewLayout = layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionElements.reduce(0, { $0 + $1.count })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlignedCollectionViewCell", for: indexPath) as! AlignedCollectionViewCell
        cell.titleLabel.text = "\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath = \(indexPath)")
    }
}

