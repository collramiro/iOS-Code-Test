//
//  ViewController.swift
//  Drink-O-Matic
//
//  Created by Ramiro Coll Doñetz on 01/08/2019.
//  Copyright © 2019 Ramiro Coll Doñetz. All rights reserved.
//

import UIKit

class HomeViewController: StatusBarAnimatableViewController {
    
    private var isFetchingDrinks: Bool = true {
        didSet {
            if isFetchingDrinks {
                //show loading view and hide ingredients label
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.isHidden = true
                    self.noInternetView.isHidden = true
                    self.activityIndicator.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.isHidden = false
                    self.noInternetView.isHidden = false
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    enum HomeState {
        case loading
        case error
        case success
    }
    
    var state: HomeState? {
        didSet {
            guard let state = state else { return }
            switch state {
            case .error:
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.isHidden = true
                    self.noInternetView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            case .loading:
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.isHidden = true
                    self.noInternetView.isHidden = true
                    self.activityIndicator.startAnimating()
                }
            case .success:
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.isHidden = false
                    self.noInternetView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var transition: CardTransition?
    
    var drinks = [Drink]()
    var drinkDetails = [String:DrinkDetails]()
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make it responds to highlight state faster
        collectionView.delaysContentTouches = false
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .init(top: 20, left: 0, bottom: 64, right: 0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        collectionView.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "card")
        
        // Add Refresh Control to Collection View
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(fetchDrinks(_:)), for: .valueChanged)
        
        fetchDrinks()
    }
    
    override var statusBarAnimatableConfig: StatusBarAnimatableConfig {
        return StatusBarAnimatableConfig(prefersHidden: false,
                                         animation: .slide)
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        fetchDrinks()
    }
}

// MARK: - Server Fetch Methods
extension HomeViewController {
   @objc private func fetchDrinks(_ sender: Any? = nil) {
        //set screen state to update UI
        state = .loading
    
        //query to get drinks list from server
        APIClient.getDrinks{ result in
            switch result {
            case .success(let drinkList):
                //clear data from arrays
                self.drinks.removeAll()
                self.drinkDetails.removeAll()
                
                if drinkList.drinks.isEmpty {
                    //response array is empty, return error screen
                    self.state = .error
                } else {
                    //update array and collectionview
                    self.drinks = drinkList.drinks
                    self.collectionView.reloadData()
                    self.state = .success
                }
            case .failure(let error):
                self.state = .error
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDrinkDetail(drinkId: String, indexPath: IndexPath, completion:@escaping (DrinkDetails)->Void)  {
        //fetch single drink detail based on id
        APIClient.getDrinkDetails(drinkId: drinkId) { (result) in
            switch result {
            case .success(let drinkDetail):
                completion(drinkDetail)
            case .failure(let error):
                self.state = .error
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CardCollectionViewCell
        //get drink from array and set it on cell
        let drink = drinks[indexPath.row]
        cell.cardContentView?.drinkModel = drink
        
        //check if we already have the drinkDetail for that drinkId
        if let drinkDetail = drinkDetails[drink.id] {
            //set the detail at the cell
            cell.cardContentView?.drinkDetailModel = drinkDetail
        } else {
            //fetch drinkDetail from server and update cell at completion
            cell.cardContentView?.isFetchingDetails = true
            fetchDrinkDetail(drinkId: drink.id, indexPath: indexPath, completion: { drinkDetail in
                self.drinkDetails[drink.id] = drinkDetail
                self.collectionView.reloadItems(at: [indexPath])
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CardCollectionViewCell
        cell.cardContentView.imageView.image = nil
        cell.cardContentView.imageView.setNeedsDisplay()
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cardHorizontalOffset: CGFloat = 20
        let cardHeightByWidthRatio: CGFloat = 1.2
        let width = collectionView.bounds.size.width - 2 * cardHorizontalOffset
        let height: CGFloat = width * cardHeightByWidthRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get tapped cell location
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Freeze highlighted state (or else it will bounce back)
        cell.freezeAnimations()
        
        // Get current frame on screen
        let currentCellFrame = cell.layer.presentation()!.frame
        
        // Convert current frame to screen's coordinates
        let cardPresentationFrameOnScreen = cell.superview!.convert(currentCellFrame, to: nil)
        
        // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
        let cardFrameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let drinkModel = drinks[indexPath.row]
        let drinkDetailModel = drinkDetails[drinkModel.id]
            
        // Set up card detail view controller
        let vc = storyboard!.instantiateViewController(withIdentifier: "cardDetailVc") as! CardDetailViewController
        vc.drinkViewModel = drinkModel.highlightedImage()
        vc.unhighlightedDrinkViewModel = drinkModel // Keep the original one to restore when dismiss
        vc.drinkDetailModel = drinkDetailModel
        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromCell: cell)
        transition = CardTransition(params: params)
        vc.transitioningDelegate = transition
        
        // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.modalPresentationStyle = .custom
        
        present(vc, animated: true, completion: { [unowned cell] in
            // Unfreeze
            cell.unfreezeAnimations()
        })
    }
}
