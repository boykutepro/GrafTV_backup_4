//
//  SearchViewController.swift
//  project
//
//  Created by tranthanh on 5/14/20.
//  Copyright © 2020 tranthanh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class SearchViewController: BaseViewController , UISearchBarDelegate  {
    
    
    
    class func newVC() -> SearchViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
    }
    
    
    let searchVideo = SearchVideoViewController.newVC()
    let searchPlaylist = SearchPlaylistViewController.newVC()
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playlistView: UIView!
    @IBOutlet weak var mainSegment: UISegmentedControl!
    
    @IBOutlet weak var searchIcon: UIImageView!
    
    let buttonBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchTextField()
        self.searchBar.delegate = self
        self.embed(searchVideo, inView: videoView)
        self.embed(searchPlaylist, inView: playlistView)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupSegment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonBar.frame.origin.x = (mainSegment.frame.width / CGFloat(mainSegment.numberOfSegments)) * CGFloat(mainSegment.selectedSegmentIndex)
    }
    
    func setupSegment() {
        mainSegment.backgroundColor = .clear
        mainSegment.tintColor = .clear
        // Add lines below the segmented control's tintColor
        mainSegment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 22)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        
        mainSegment.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 22)!,
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8089709878, green: 0.005250724964, blue: 0.4301971793, alpha: 1)
        ], for: .selected)
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = #colorLiteral(red: 0.8089709878, green: 0.005250724964, blue: 0.4301971793, alpha: 1)
        view.addSubview(buttonBar)
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: mainSegment.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        buttonBar.leftAnchor.constraint(equalTo: mainSegment.leftAnchor).isActive = true
      
        buttonBar.frame.origin.x = (mainSegment.frame.width / CGFloat(mainSegment.numberOfSegments)) * CGFloat(mainSegment.selectedSegmentIndex)

        
        buttonBar.widthAnchor.constraint(equalTo: mainSegment.widthAnchor, multiplier: 1 / CGFloat(mainSegment.numberOfSegments)).isActive = true
        
        
        mainSegment.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.mainSegment.frame.width / CGFloat(self.mainSegment.numberOfSegments)) * CGFloat(self.mainSegment.selectedSegmentIndex)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private func setupSearchTextField() {
        let searchTextField: UITextField = searchBar.textField
        searchTextField.layer.cornerRadius = 18
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.textAlignment = NSTextAlignment.left
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search by songs, albums, artists,..."
        searchTextField.rightViewMode = .always
        searchTextField.backgroundColor = .clear
        searchTextField.textColor = .white
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchIcon.isHidden = true
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        searchBar.resignFirstResponder()
        if let keyword = searchBar.text {
            self.searchVideo.keyword = keyword
            self.searchVideo.getSearchSpoty()
            self.searchPlaylist.keyword = keyword
            self.searchPlaylist.getSearchSpoty()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchIcon.isHidden = false
        searchBar.resignFirstResponder()
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
        self.searchVideo.items = []
        self.searchVideo.tableView.reloadData()
        self.searchPlaylist.items = []
        self.searchPlaylist.tableView.reloadData()
        
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func settingPressed(_ sender: UIButton) {
        let settingVC = LeftViewController.newVC()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    
    @IBAction func changeSegmentValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            videoView.alpha = 1
            playlistView.alpha = 0
        default:
            playlistView.alpha = 1
            videoView.alpha = 0
        }
    }
    
    
    
}


extension UIViewController {
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
