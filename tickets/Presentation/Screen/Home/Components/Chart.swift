import Charts
import Foundation
import SwiftUI

struct ChartExampleView: View {
    let tickets: [Ticket]

    var body: some View {
        VStack {
            Chart(tickets) { ticket in
                LineMark(
                    x: .value("Categoría", ticket.date),
                    y: .value("Cantidad", ticket.total)
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
                .interpolationMethod(.cardinal)
                .symbol(Circle().strokeBorder(lineWidth: 1))
                .symbolSize(0)
            }
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 100)
            .padding()
        }
    }
}
