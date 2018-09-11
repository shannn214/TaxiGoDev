//
//  FavoriteView.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class FavoriteView: UIView {

    @IBOutlet var containView: UIView!
    @IBOutlet weak var favTableView: UITableView!
    
    var favorite = [Favorite]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
        setupTableView()
    }
    
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("FavoriteView", owner: self, options: nil)
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    private func setupTableView() {
        
        favTableView.separatorStyle = .singleLine
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.rowHeight = UITableViewAutomaticDimension
        favTableView.estimatedRowHeight = 100
        
        let nib = UINib(nibName: String(describing: FavoriteTableViewCell.self), bundle: nil)
        favTableView.register(nib, forCellReuseIdentifier: String(describing: FavoriteTableViewCell.self))
        
    }

}

extension FavoriteView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return favorite.count
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = favTableView.dequeueReusableCell(withIdentifier: String(describing: FavoriteTableViewCell.self)) as? FavoriteTableViewCell else { return UITableViewCell() }
                
//        cell.favName.text = favorite[indexPath.row].address
        cell.favName.text = "Ahahahahhaha uuuu"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}