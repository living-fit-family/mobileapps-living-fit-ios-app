// 2. Update import statements
import SwiftUI
import SendbirdUIKit
// 3. Create a UIViewController class
class ChannelViewController : UIViewController {
    private var channelId: String
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    init(channelId: String) {
        self.channelId = channelId
        super.init(nibName: nil, bundle: nil)
    }
    
    // 3a. Create a UINavigationController with the Sendbird channel list
    //     view controller as it's root view controller
    @objc func displaySendbirdChanel(){
        let clvc = SBUGroupChannelViewController(channelURL: channelId)
        let navc = UINavigationController(rootViewController: clvc)
        navc.modalPresentationStyle = .fullScreen
        present(navc, animated: true)
    }
    // 3b. Present the UINavigationController above
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displaySendbirdChanel()
    }
}
// 4. Create a UIViewControllerRepresentable struct
struct ChannelViewContainer: UIViewControllerRepresentable {
    var channelId: String
    // 4a. Set the typealias to the class in step 3
    typealias UIViewControllerType = ChannelViewController
    // 4b. Have the makeUIViewController return an instance of the class from step 3
    func makeUIViewController(context: Context) -> ChannelViewController {
        return ChannelViewController(channelId: channelId)
    }
    // 4c. Add the required updateUIViewController function
    func updateUIViewController(_ uiViewController: ChannelViewController, context: Context) {
    }
}
