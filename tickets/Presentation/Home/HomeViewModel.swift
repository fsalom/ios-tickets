import SwiftUI
import TripleA

class HomeViewModel: ObservableObject {
    struct UIState {
        var tickets = [Ticket]()
        var error: AuthError?
    }

    @Published var uiState = UIState()

    private let ticketsUseCase: TicketsUseCase

    init(ticketsUseCase: TicketsUseCase) {
        self.ticketsUseCase = ticketsUseCase
    }

    @MainActor
    func getAll2() {
        let url = URL(string: "https://tickets.rudo.es/api/v1/tickets/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer xDy5KC1LonBp04lePjjuHLm5HdQRk60LWoJOvAlR8RU", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("🔽 Código de estado: \(response.statusCode)")
            }
            if let data = data {
                print("🔽 Respuesta: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }
        task.resume()

    }

    @MainActor
    func getAll() {
        print("Ejecutando getAll en el MainActor: \(Thread.isMainThread)")
        getAll2()
        Task {
            print("Ejecutando Task en el MainActor: \(Thread.isMainThread)")
            do {
                self.uiState.tickets = try await ticketsUseCase.getAll()
            } catch {
                self.uiState.error = .notVerified
            }
        }
    }
}

