//
//  NativeAdView.swift
//
//  Copyright 2018-2019 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import MoPub
import UIKit

/**
 Provides a common native ad view.
 */
@IBDesignable
public class NativeAdView: UIView {
    // IBOutlets
    @IBOutlet public var titleLabel: UILabelPadding!
    @IBOutlet public var mainTextLabel: UILabel!
    @IBOutlet public var callToActionLabel: UILabel!
    @IBOutlet public var iconImageView: UIImageView!
    @IBOutlet public var mainImageView: UIImageView!
    @IBOutlet public var privacyInformationIconImageView: UIImageView!
//    @IBOutlet weak var videoView: UIView!

    // IBInspectable
    @IBInspectable var nibName: String? = "NativeAdView"

    // Content View
    private(set) var contentView: UIView?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupNib()
    }

    /**
     The function is essential for supporting flexible width. The native view content might be
     stretched, cut, or have undesired padding if the height is not estimated properly.
     */
    static func estimatedViewHeightForWidth(_ width: CGFloat) -> CGFloat {
        // The numbers are obtained from the constraint defined in the xib file
        let padding: CGFloat = 8
        let iconImageViewWidth: CGFloat = 50
        let estimatedNonMainContentCombinedHeight: CGFloat = 72 // [title, main text, call to action] labels

        let mainContentWidth = width - padding * 3 - iconImageViewWidth
        let mainContentHeight = mainContentWidth / 2 // the xib has a 2:1 width:height ratio constraint
        return floor(mainContentHeight + estimatedNonMainContentCombinedHeight + padding * 2)
    }

    func setupNib() {
        guard let view = loadViewFromNib(nibName: nibName) else { return }

        mainImageView.accessibilityIdentifier = AccessibilityIdentifier.nativeAdImageView

        addSubview(view)
        contentView = view
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = bounds
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupNib()
        contentView?.prepareForInterfaceBuilder()
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 100
        let area = bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
    
}

extension NativeAdView: MPNativeAdRendering {
    // MARK: - MPNativeAdRendering

    public func nativeTitleTextLabel() -> UILabel! {
        return titleLabel
    }

    public func nativeMainTextLabel() -> UILabel! {
        return mainTextLabel
    }

    public func nativeCallToActionTextLabel() -> UILabel! {
        return callToActionLabel
    }

    public func nativeIconImageView() -> UIImageView! {
        return iconImageView
    }

    public func nativeMainImageView() -> UIImageView! {
        return mainImageView
    }

    public func nativePrivacyInformationIconImageView() -> UIImageView! {
        return privacyInformationIconImageView
    }

//    func nativeVideoView() -> UIView! {
//        return videoView
//    }
}


public class UILabelPadding : UILabel {
    
    private var padding = UIEdgeInsets.zero
    
    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}

