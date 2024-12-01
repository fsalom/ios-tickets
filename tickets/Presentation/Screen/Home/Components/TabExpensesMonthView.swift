import SwiftUI

struct TabExpensesMonthView: View {
    let ticketsPerMonth: TicketsPerMonth

    var body: some View {
        HStack {
            VStack {
                Text(ticketsPerMonth.monthWithFormat)
                    .font(.footnote)
                    .fontWeight(.bold)
                Text(ticketsPerMonth.totalWithFormat)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 16)
                Text("\(ticketsPerMonth.totalDifferencePreviousMonthWithFormat) respecto al mes anterior")
                    .font(.footnote)
                //ChartTicketsExpensesView(tickets: ticketsPerMonth.tickets)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
        .foregroundStyle(Color.black)
        .background(
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
