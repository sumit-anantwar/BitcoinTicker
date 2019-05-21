import UIKit
import Swinject
import SwinjectStoryboard

// This enables injection of the initial view controller from the app's main
//   storyboard project settings. So, this is the starting point of the
//   dependency tree.
extension SwinjectStoryboard {
    public class func setup() {
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistryImpl(container: defaultContainer)
        }
        
        let dependencyRegistry: DependencyRegistry = AppDelegate.dependencyRegistry
        
        func main() {
            
            // This closure gets called when DashboardViewController completes initialization from the Storyboard
            dependencyRegistry.container.storyboardInitCompleted(DashboardViewController.self) { (r, vc) in
                
                // Resolve the ViewModel
                let viewModel = r.resolve(DashboardViewModel.self)!
                // Configure the VC with the ViewModel 
                vc.configure(with: viewModel,
                             orderBookCellMaker: dependencyRegistry.makeOrderBookCell,
                             orderBookSectionHeaderMaker: dependencyRegistry.makeOrderBookSectionHeader)
            }
        }
        
        main()
    }
}
