//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Andreas Zwikirsch on 16.08.22.
//

import SwiftUI
import CodeScanner
import UserNotifications


struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if filter == .none {
                            Image(systemName: prospect.isContacted ? "bubble.left.circle.fill" : "bubble.left.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(prospect.isContacted ? .green : .gray)
                                .frame(width: 28, height: 28)
                                .padding(.trailing, 8)
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect )
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarItems(
                leading:
                    Menu {
                        VStack {
                            Button("Sort by name") {
                                prospects.peopleFilter = .name
                            }
                            Button("Sort by recent") {
                                prospects.peopleFilter = .none
                            }
                        }
                    } label: {
                        HStack {
                            Text("Sort By")
                                .bold()
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                    }
//                    Button {
//                        // change sort preferences with context menu
//                    } label: {
//                        HStack {
//                            Text("Sort By")
//                                .bold()
//                            Image(systemName: "arrow.up.arrow.down.circle")
//                        }
////                        Label("Sort By", systemImage: "arrow.up.arrow.down.circle")
//                    }
                ,
                trailing:
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
            )
            //            .toolbar {
            //                Button {
            //                    isShowingScanner = true
            //                } label: {
            //                    Label("Scan", systemImage: "qrcode.viewfinder")
            //                }
            //            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "DuckCode\nlemon.code@hackingwithswift.com", completion: handleScan)
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted peapole"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.orderedPeople
        case .contacted:
            return prospects.orderedPeople.filter { $0.isContacted }
        case .uncontacted:
            return prospects.orderedPeople.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
