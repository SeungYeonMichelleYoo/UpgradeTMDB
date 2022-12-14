//
//  NetflixViewController.swift
//  UpgradeTMDB
//
//  Created by SeungYeon Yoo on 2022/08/09.
//

import UIKit
import Kingfisher

class NetflixViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray, .yellow, .black]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](51...60),
        [Int](61...70),
        [Int](71...80),
        [Int](81...90)
    ]
    
    var movieList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        GenreAPIManager.shared.requestImage { value in //value = posterList
            self.movieList = value
            self.mainTableView.reloadData()
        }
       
    }
}

//MARK: - TableView
extension NetflixViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        let genreTitles = [String] (GenreAPIManager.shared.genreList.values)
        cell.titleLabel.text = "\(genreTitles[indexPath.section]) 장르 추천"
        cell.titleLabel.textColor = .white
        cell.contentCollectionView.backgroundColor = .lightGray
        
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        
        cell.contentCollectionView.collectionViewLayout = collectionViewLayout()
        cell.contentCollectionView.isPagingEnabled = true //자석처럼 셀이 넘어감(오픈소스:ImageSlideShow). device width와 셀이 같을 때
        
        cell.contentCollectionView.tag = indexPath.section // 각 셀 구분 짓기
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
       
        cell.contentCollectionView.reloadData() //인덱스 오류 해결
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: -CollectionView
extension NetflixViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
            cell.cardView.posterImageView.backgroundColor = .systemIndigo
            cell.cardView.posterImageView.contentMode = .scaleToFill
            cell.cardView.contentLabel.textColor = .white
            cell.cardView.contentLabel.text = ""
        
        let url = URL(string: "\(GenreAPIManager.shared.imageURL)\(movieList[collectionView.tag][indexPath.item])")
        cell.cardView.posterImageView.kf.setImage(with: url)

                    
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}

