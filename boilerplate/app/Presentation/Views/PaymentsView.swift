import SwiftUI

struct PaymentsView: View {
    @StateObject private var viewModel = PaymentsViewModel()
    var body: some View {
        VStack {
            Spacer()
            Text(NSLocalizedString("payments", comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            } else {
                List(viewModel.transactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.title)
                                .font(.headline)
                            Text("\(transaction.date, formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(String(format: "$%.2f", transaction.amount))
                            .foregroundColor(transaction.amount < 0 ? .red : .green)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
            Spacer()
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.loadTransactions()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}() 