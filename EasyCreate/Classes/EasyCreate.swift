import UIKit


/// These Nib protocols are broken up to allow more explicit access to the functionality.
public protocol NibNamed: class {
    /**
     The default implementation returns (`Self.self`). The class in string format. Which assumes the class name is the
     same as the '.xib' name. If they are different you can override it to provide the correct '.xib' name.
     */
    static var nibName: String { get }
}
extension NibNamed {
    public static var nibName: String { return String(describing: Self.self) }
}




/// Allows access to a nib instance of the conforming class
public protocol Nibbed: NibNamed {
    /// Creates a UINib of the class if one exists.
    /// Will use default `nibName` if one is not provided.
    static var nib: UINib { get }
}

extension Nibbed {
    public static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}





/**
 Your UIView subclass should conform to this when you want to instantiate a view from a nib.
 By default it will use the name of the class to find the nib. You can implement this yourself
 if the class name is different than the .xib name.
 
 Your type cannot be subclassable. If a class conforms to this, it must be `final`.
 */
public protocol NibInstantiating: NibNamed {
    /// See extension that provides `viewFromNib`.
}

public extension NibInstantiating where Self: UIView {
    
    /**
     Creates a UIView (or subclass) using `nibName` to generate it.
     
     - returns: `Self` This should be a subclass of `UIView`.
     
     - seealso: `nibName` This is used to determine which '.xib' file to use
     
     */
    public static func viewFromNib() -> Self {
        var view: Self!
        let objects = Bundle(for: self).loadNibNamed(nibName, owner: nil, options: nil)
        for object in objects ?? [] {
            guard let foundView = object as? Self else { continue }
            view = foundView
            break
        }
        assert(view != nil, "Could not find object of type: \(Self.self) \(#function)")
        return view
    }
    
}


public protocol StoryboardInstantiating: class {
    
    /**
     The name of the view controller to be created. The default implementation returns (`Self.self`). The class in string format.
     */
    static var viewControllerName: String { get }
    
    /**
     You must provide the name of the storyboard on which the UIViewController subclass exists.
     */
    static var storyboardName: String { get }
}

public extension StoryboardInstantiating where Self: UIViewController {
    
    /**
     Creates a `Self` (UIViewController subclass) from the given parameters.
     
     - returns: `Self` This will be a `UIViewController` subclass generated from a `UIStoryboard`
     */
    public static func viewControllerFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self) )
        return storyboard.instantiateViewController(withIdentifier: viewControllerName) as! Self
    }
    
    public static var viewControllerName: String { return String(describing: Self.self) }
    public static var storyboardName: String { return String(describing: Self.self) }
}
