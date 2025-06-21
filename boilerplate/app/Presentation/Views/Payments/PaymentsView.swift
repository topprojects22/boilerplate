import SwiftUI

struct PaymentsView: View {
    @StateObject private var viewModel = PaymentsViewModel()
    @State private var selectedFilter = 0
    @State private var isRefreshing = false
    @State private var showingNewPayment = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Summary
                VStack(spacing: 16) {
                    HStack {
                        Text("Payments")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: { showingNewPayment = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    // Payment Summary Cards
                    HStack(spacing: 16) {
                        SummaryCard(
                            title: "Total Balance",
                            amount: "$12,345.67",
                            icon: "dollarsign.circle.fill",
                            color: .blue
                        )
                        SummaryCard(
                            title: "Pending",
                            amount: "$1,234.56",
                            icon: "clock.fill",
                            color: .orange
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Filter Options
                VStack(alignment: .leading, spacing: 16) {
                    Text("Filter")
                        .font(.headline)
                    
                    Picker("Filter", selection: $selectedFilter) {
                        Text("All").tag(0)
                        Text("Income").tag(1)
                        Text("Expenses").tag(2)
                        Text("Pending").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Recent Transactions
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Transactions")
                            .font(.headline)
                        Spacer()
                        Button("See All") {
                            // Action
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.transactions) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Actions")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        QuickActionButton(
                            title: "Send Money",
                            icon: "arrow.up.circle.fill",
                            color: .blue
                        )
                        QuickActionButton(
                            title: "Request",
                            icon: "arrow.down.circle.fill",
                            color: .green
                        )
                        QuickActionButton(
                            title: "Split Bill",
                            icon: "person.2.fill",
                            color: .purple
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .refreshable {
            isRefreshing = true
            await viewModel.loadTransactions()
            isRefreshing = false
        }
        .sheet(isPresented: $showingNewPayment) {
            NewPaymentView()
        }
        .onAppear {
            viewModel.loadTransactions()
        }
    }
}

// MARK: - Supporting Views
struct SummaryCard: View {
    let title: String
    let amount: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(amount)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            // Transaction Icon
            Circle()
                .fill(transaction.amount < 0 ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: transaction.amount < 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.title3)
                        .foregroundColor(transaction.amount < 0 ? .red : .green)
                )
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(transaction.date, formatter: dateFormatter)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", abs(transaction.amount)))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(transaction.amount < 0 ? .red : .green)
                Text(transaction.amount < 0 ? "Sent" : "Received")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NewPaymentView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipient")) {
                    TextField("Name or Email", text: .constant(""))
                }
                
                Section(header: Text("Amount")) {
                    TextField("$0.00", text: .constant(""))
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Note")) {
                    TextField("Add a note", text: .constant(""))
                }
            }
            .navigationTitle("New Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// MARK: - Preview
struct PaymentsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentsView()
    }
} 
