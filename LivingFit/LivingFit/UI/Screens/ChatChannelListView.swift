// 2. Update import statements
import SwiftUI
import SendbirdUIKit
// 3. Create a UIViewController class
class ChannelListViewController : UIViewController {
    // 3a. Create a UINavigationController with the Sendbird channel list
    //     view controller as it's root view controller
    @objc func displaySendbirdChanelList(){
        let clvc = SBUGroupChannelListViewController()
        let navc = UINavigationController(rootViewController: clvc)
        navc.modalPresentationStyle = .overFullScreen
        navc.modalTransitionStyle = .crossDissolve
        present(navc, animated: true)
    }
    // 3b. Present the UINavigationController above
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displaySendbirdChanelList()
    }
}
// 4. Create a UIViewControllerRepresentable struct
struct ChannelListViewContainer: UIViewControllerRepresentable {
    // 4a. Set the typealias to the class in step 3
    typealias UIViewControllerType = ChannelListViewController
    // 4b. Have the makeUIViewController return an instance of the class from step 3
    func makeUIViewController(context: Context) -> ChannelListViewController {
        return ChannelListViewController()
    }
    // 4c. Add the required updateUIViewController function
    func updateUIViewController(_ uiViewController: ChannelListViewController, context: Context) {
    }
}
