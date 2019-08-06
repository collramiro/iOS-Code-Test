//
//  CardContentView.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Wirawit Rueopas on 3/4/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable final class CardContentView: UIView, NibLoadable {

    static let linesOfVisibleIngredients = 2

    var drinkModel: Drink? {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            titleLabel.text = drinkModel?.name
            if let imageString = drinkModel?.thumbUrl, let imageUrl = URL.init(string: imageString) {
                imageView.sd_imageTransition = .fade
                imageView.sd_setImage(with: imageUrl, completed: nil)
            }
        }
    }
    
    var drinkDetailModel: DrinkDetails? {
        didSet {
            let ingredientsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: UIColor.white]
            
            let moreIngredientsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .light),
                .foregroundColor: UIColor.white]
            
            let ingredientsAttributedString = NSMutableAttributedString()

            if let ingredientsToShow = drinkDetailModel?.ingredients.prefix(CardContentView.linesOfVisibleIngredients) {
                for ingredient in ingredientsToShow {
                    var ingredientString = ""
                    if ingredientsAttributedString.length > 0 {
                        ingredientString.append("\n")
                    }
                    ingredientString.append("• \(ingredient)")
                    
                    ingredientsAttributedString.append(NSAttributedString(string: ingredientString, attributes: ingredientsAttributes))
                }
            }
            
            if let ingredientsToCount = drinkDetailModel?.ingredients.dropFirst(CardContentView.linesOfVisibleIngredients), !ingredientsToCount.isEmpty {
                ingredientsAttributedString.append(NSAttributedString(string: "\nand \(ingredientsToCount.count) ingredients more", attributes: moreIngredientsAttributes))
            }

            ingredientsLabel.attributedText = ingredientsAttributedString
            
            isFetchingDetails = false
        }
    }
    
    var isFetchingDetails: Bool = true {
        didSet {
            if isFetchingDetails {
                //show loading view and hide ingredients label
                UIView.animate(withDuration: 0.3) {
                    self.ingredientsLabel.isHidden = true
                    self.activityIndicator.startAnimating()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.ingredientsLabel.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageToTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToBottomAnchor: NSLayoutConstraint!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        commonSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        commonSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }

    private func commonSetup() {
        // *Make the background image stays still at the center while we animationg,
        // else the image will get resized during animation.
        imageView.contentMode = .scaleAspectFill
        setFontState(isHighlighted: false)
    }
    
    // This "connects" highlighted (pressedDown) font's sizes with the destination card's font sizes
    func setFontState(isHighlighted: Bool) {
        if isHighlighted {
//            titleLabel.font = UIFont.systemFont(ofSize: 24 * GlobalConstants.cardHighlightedFactor, weight: .bold)
//            ingredientsLabel.font = UIFont.systemFont(ofSize: 40 * GlobalConstants.cardHighlightedFactor, weight: .semibold)
        } else {
//            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//            ingredientsLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        }
    }
}
