import SwiftUI

class HomeViewModel: ObservableObject {
    struct UIState {
        var tickets = [Ticket]()
        var error: AuthError?
    }

    let notificationCenter = UNUserNotificationCenter.current()

    @Published var uiState = UIState()

    private let ticketsUseCase: TicketsUseCases
    private let fcmUseCases: FCMUseCases
    private let userUseCases: UserUseCases

    init(ticketsUseCase: TicketsUseCases,
         fcmUseCases: FCMUseCases,
         userUseCases: UserUseCases
    ) {
        self.ticketsUseCase = ticketsUseCase
        self.fcmUseCases = fcmUseCases
        self.userUseCases = userUseCases
    }

    @MainActor
    func getAll() {
        Task {
                do {
                    let tickets = try await ticketsUseCase.getAll()
                    DispatchQueue.main.async {
                        self.uiState.tickets = tickets
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.uiState.error = .notVerified
                    }
                }
            }
    }

    private func updateFCM() {
        Task {
            guard let fcm = fcmUseCases.get() else { return }
            try? await userUseCases.update(fcmToken: fcm)
        }
    }

    private func requestNotificationPermission() {
        Task {
            try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
        }
    }

    func checkAndRequestNotificationPermissionIfNecessary() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationPermission()
            case .denied:
                print("El usuario denegó los permisos.")
            case .authorized, .provisional, .ephemeral:
                self.updateFCM()
            @unknown default:
                break
            }
        }
    }
}

