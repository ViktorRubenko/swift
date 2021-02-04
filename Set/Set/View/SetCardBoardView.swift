//
//  SetCardBoardView.swift
//  Set
//
//  Created by Victor Rubenko on 31.01.2021.
//

import UIKit

class SetCardBoardView: UIView {
    
    var cardViews = [SetCardView()] {
        willSet {
            removeCardSubviews()
        }
        didSet {
            addCardSubviews()
            setNeedsLayout()
        }
    }
    
    private func removeCardSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
    }
    
    private func addCardSubviews() {
        for card in cardViews {
            self.addSubview(card)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cellAspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        for cardViewIndex in cardViews.indices {
            cardViews[cardViewIndex].frame = grid[cardViewIndex]!.insetBy(dx: 2, dy: 2)
        }
    }

    struct Constants {
        static let cellAspectRatio: CGFloat = 0.57
    }
    
}
