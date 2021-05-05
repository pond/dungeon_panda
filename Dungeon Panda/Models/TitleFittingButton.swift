//
//  TitleFittingButton.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 2/05/21 from:
//
//    https://stackoverflow.com/a/61168272
//

import UIKit

class TitleFittingButton: UIButton
{
    override var intrinsicContentSize: CGSize
    {
        var titleSize = titleLabel?.intrinsicContentSize ?? .zero

        titleSize.width  += titleEdgeInsets.left + titleEdgeInsets.right
        titleSize.height += titleEdgeInsets.top + titleEdgeInsets.bottom

        return titleSize
    }
}
