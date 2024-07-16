import FirebaseAuth

let appleProviderId = "apple.com"
let googleProviderId = "google.com"

extension FirebaseAuth.User {
    var isLinkedWithAppleId: Bool {
        providerData.contains(where: { $0.providerID == appleProviderId })
    }
    var isLinkedWithGoogle: Bool {
        providerData.contains(where: { $0.providerID == googleProviderId })
    }
}
