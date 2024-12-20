import SwiftUI

class HomeViewModel: ObservableObject {
    struct UIState {
        var ticketsPerMonths = [TicketsPerMonth]()
        var ticketsOfMonth = [Ticket]()
        var loading: Bool = true
        var error: AuthError?
    }

    let notificationCenter = UNUserNotificationCenter.current()
    private var selectedMonth = 0
    private var myTicketsPerMonths: [TicketsPerMonth]?
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

        NotificationCenter.default.removeObserver(self,
                                                  name: .ticketReceived,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getTicketsPerMonth),
                                               name: .ticketReceived,
                                               object: nil)
    }

    @objc @MainActor
    func getTicketsPerMonth() {
        Task {
            do {
                let ticketsPerMonths = try await ticketsUseCase.getTicketsPerMonth()
                DispatchQueue.main.async {
                    self.uiState.ticketsPerMonths = ticketsPerMonths
                    self.uiState.ticketsOfMonth = ticketsPerMonths[self.selectedMonth].tickets
                    self.uiState.loading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.uiState.error = .notVerified
                    self.uiState.loading = false
                }
            }
        }
    }

    func changeMonth(index: Int) {
        self.selectedMonth = index
        self.uiState.ticketsOfMonth = self.uiState.ticketsPerMonths[index].tickets
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

