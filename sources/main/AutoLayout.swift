import UIKit

/**
 Autolayout library.

 This exist because programmatically using the Apple APIs (except VFL) forces you to read so much
 that you lose track of the code meaning.

 All elements are contained in the 'al' namespace to avoid polluting the view class.
 
 Things you can do:
 ```
 view.al.pin()
 view.al.pinToLayoutMargins()
 view.al.pinToSafeArea()
 view.al.pinToReadableContent()
 
 view.al.pin(sides: [.leading, .trailing])
 view.al.pinToLayoutMargins(sides: [.top, .bottom])
 view.al.pinToSafeArea(sides: [.leading, .top, .trailing])
 view.al.pinToReadableContent(sides: [.top])
 
 view.al.set(width: 0)
 view.al.set(height: 0, priority: .defaultHigh)
 view.al.set(size: CGSize.zero)
 
 view.al.center()
 view.al.centerX()
 view.al.centerY()
 
 view.al.center(to: view2)
 view.al.centerX(to: view2)
 view.al.centerY(to: view2)
 
 // Enumerate all non nil views and apply the following Visual Format Language
 view.al.applyVFL([
     "H:[handle(36)]",
     "V:[handle(5)]"
 ])
 ```
 */
public final class AutoLayout
{
    private let base: UIView

    var superview: UIView {
        precondition(base.superview != nil, "This operation requires a non nil superview")
        return base.superview!
    }

    // MARK: - Initializing

    public init(_ base: UIView)
    {
        self.base = base
        base.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Constraining anchors
    
    public enum Anchor {
        case bottom
        case centerX
        case centerY
        case firstBaseline
        case height
        case lastBaseline
        case leading
        case left
        case right
        case top
        case trailing
        case width
    }
    
    public func constraint(anchors: [Anchor], to view: UIView) {
        
        anchors.forEach {
            
            switch $0 {
            case .bottom: base.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            case .centerX: base.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            case .centerY: base.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            case .firstBaseline: base.firstBaselineAnchor.constraint(equalTo: view.firstBaselineAnchor).isActive = true
            case .height: base.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            case .lastBaseline: base.lastBaselineAnchor.constraint(equalTo: view.lastBaselineAnchor).isActive = true
            case .leading: base.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            case .left: base.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            case .right: base.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            case .top: base.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            case .trailing: base.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            case .width: base.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            }
        }
    }
    
    // MARK: - Centering views
    
    public func center(to someView: UIView? = nil, constant: CGFloat = 0) {
        centerX(to: someView, constant: constant)
        centerY(to: someView, constant: constant)
    }
    public func centerX(to someView: UIView? = nil, constant: CGFloat = 0) {
        base.centerXAnchor.constraint(equalTo: (someView ?? superview).centerXAnchor, constant: constant).isActive = true
    }
    public func centerY(to someView: UIView? = nil, constant: CGFloat = 0) {
        base.centerYAnchor.constraint(equalTo: (someView ?? superview).centerYAnchor, constant: constant).isActive = true
    }
    
    // MARK: - Setting single attributes
    
    public func set(size: CGSize, priority: UILayoutPriority = .required) {
        set(width: size.width, priority: priority)
        set(height: size.height, priority: priority)
    }
    
    @discardableResult
    public func set(height: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = base.heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func set(width: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraint = base.widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Pinning view edges
    
    public func pin(
        to someView: UIView? = nil,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        sides: [Sides] = [.top, .leading, .bottom, .trailing]) {
        pinToView(someView ?? superview, insets: insets, sides: sides)
    }
    
    public func pinToLayoutMargins(
        of someView: UIView? = nil,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        sides: [Sides] = [.top, .leading, .bottom, .trailing]) {
        pinToLayoutGuide(guide: (someView ?? superview).layoutMarginsGuide, insets: insets, sides: sides)
    }
    
    public func pinToSafeArea(
        of someView: UIView? = nil,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        sides: [Sides] = [.top, .leading, .bottom, .trailing]) {
        pinToLayoutGuide(guide: (someView ?? superview).safeAreaLayoutGuide, insets: insets, sides: sides)
    }
    
    public func pinToReadableContent(
        of someView: UIView? = nil,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        sides: [Sides] = [.top, .leading, .bottom, .trailing]) {
        pinToLayoutGuide(guide: (someView ?? superview).readableContentGuide, insets: insets, sides: sides)
    }

    private func pinToView(
        _ someView: UIView,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        sides: [Sides])
    {
        sides.forEach { side in
            switch side {
            case .top:      base.topAnchor      .constraint(equalTo: someView.topAnchor,      constant: insets.top)    .isActive = true
            case .leading:  base.leadingAnchor  .constraint(equalTo: someView.leadingAnchor,  constant: insets.left)   .isActive = true
            case .bottom:   base.bottomAnchor   .constraint(equalTo: someView.bottomAnchor,   constant: -insets.bottom).isActive = true
            case .trailing: base.trailingAnchor .constraint(equalTo: someView.trailingAnchor, constant: -insets.right) .isActive = true
            }
        }
    }
    
    private func pinToLayoutGuide(
        guide: UILayoutGuide,
        insets: UIEdgeInsets = UIEdgeInsets.zero,
        sides: [Sides])
    {
        sides.forEach { side in
            switch side {
            case .top:      base.topAnchor      .constraint(equalTo: guide.topAnchor,      constant: insets.top)    .isActive = true
            case .leading:  base.leadingAnchor  .constraint(equalTo: guide.leadingAnchor,  constant: insets.left)   .isActive = true
            case .bottom:   base.bottomAnchor   .constraint(equalTo: guide.bottomAnchor,   constant: -insets.bottom).isActive = true
            case .trailing: base.trailingAnchor .constraint(equalTo: guide.trailingAnchor, constant: -insets.right) .isActive = true
            }
        }
    }
    
    // MARK: - Applying VFL constraints
    
    public func applyVFL(_ constraints: [String],
                         options: NSLayoutConstraint.FormatOptions = [],
                         metrics: [String: Any]? = nil,
                         views: [String: UIView]? = nil)
    {
        base.translatesAutoresizingMaskIntoConstraints = false
        var viewDictionary = [String: UIView]()
        if let views = views {
            viewDictionary = views
        } else {
            viewDictionary = enumerateSubViews()
            viewDictionary["baseView"] = base
        }
        viewDictionary.values.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        constraints.forEach {
            base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: $0, options: options, metrics: metrics, views: viewDictionary))
        }
    }

    /// Returns every non nil instance UIView variable in the given view, indexed by its variable name.
    /// This is useful to create view dictionaries and apply visual format language constraints.
    public func enumerateSubViews() -> [String: UIView]
    {
        var views = [String: UIView]()
        let mirror = Mirror(reflecting: base)
        let addToViewsClosure: ((Mirror.Child) -> Void) = { child in
            child.label.flatMap { label in
                #if swift(>=5.1)
                let key = label.replacingOccurrences(of: "$__lazy_storage_$_", with: "")
                #else
                let key = label.replacingOccurrences(of: ".storage", with: "")
                #endif
                views[key] = child.value as? UIView
            }
        }
        mirror.children.forEach(addToViewsClosure)
        mirror.superclassMirror?.children.forEach(addToViewsClosure)
        return views
    }
}

/// Extends views with an Auto Layout namespace.
public extension UIView {

    /// AutoLayout namespace
    var al: AutoLayout {
        return AutoLayout(self)
    }
}

/// Indicates sides of a view instance.
public enum Sides {
    case top, trailing, bottom, leading
}
