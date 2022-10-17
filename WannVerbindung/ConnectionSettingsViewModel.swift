//
//  ConnectionSettingsViewModel.swift
//  WannVerbindung
//
//  Created by Florian Rhein on 14.10.22.
//

import Foundation
import WannVerbindungServices
import WidgetKit

@MainActor internal class ConnectionSettingsViewModel: ObservableObject {
    @Published internal var homeStation: String
    @Published internal var workStation: String

    @Published internal var outboundStart: Date = .distantPast
    @Published internal var outboundEnd: Date = .distantPast
    @Published internal var inboundStart: Date = .distantPast
    @Published internal var inboundEnd: Date = .distantPast

    internal let transportService: TransportService = TransportService()

    internal init() {
        let userDefautsSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")
        self.homeStation = userDefautsSuite?.string(forKey: "homeStation") ?? ""
        self.workStation = userDefautsSuite?.string(forKey: "workStation") ?? ""

    }

    internal func saveConfiguration() {
        let userDefaultSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")
        userDefaultSuite?.set(homeStation, forKey: "homeStation")
        userDefaultSuite?.set(workStation, forKey: "workStation")
        userDefaultSuite?.set(outboundStart, forKey: "outboundStart")
        userDefaultSuite?.set(outboundEnd, forKey: "outboundEnd")
        userDefaultSuite?.set(inboundStart, forKey: "inboundStart")
        userDefaultSuite?.set(inboundEnd, forKey: "inboundEnd")
        WidgetCenter.shared.reloadTimelines(ofKind: "NextDepartureIPhoneWidget")
        WidgetCenter.shared.reloadTimelines(ofKind: "NextDepartureWatchWidget")

        // TODO: add some kind of success notification
    }

    internal func searchConnections() {
        let homeStationCode = Int(homeStation)!
        let workStationCode = Int(workStation)!
        Task {
            let journey = try await transportService.getJourney(from: homeStationCode, to: workStationCode)
            print(journey)
        }
    }
}
