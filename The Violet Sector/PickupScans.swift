// Created by João Santos for project The Violet Sector.

import SwiftUI

struct PickupScans: View {
    @StateObject private var model = Model(resource: "pickups.php", responseType: ModelResponse.self)
    @StateObject private var pickupAction = Action(resource: "pickups2.php", responseType: PickupResponse.self)

    var body: some View {
        Page(model: model) {(response) in
            if response.canPickup {
                Button("Scan (\(response.pickupCost))", action: {pickupAction.perform(query: [:], completionHandler: {model.refresh()})})
            }
            if let pickupResponse = pickupAction.response, let message = pickupResponse.message {
                Text(verbatim: message)
                if let canAttack = pickupResponse.canAttack, canAttack {
                    Text(verbatim: "Enemy scan goes here")
                }
                if let randomHyperGate = pickupResponse.randomHyperGate, randomHyperGate {
                    Text(verbatim: "Hyper button goes here")
                }
            }
        }
    }

    private struct ModelResponse: Decodable {
        let canPickup: Bool
        let pickupCost: Int

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            canPickup = try container.decodeIfPresent(Bool.self, forKey: .canPickup) ?? false
            pickupCost = try container.decodeIfPresent(Int.self, forKey: .pickupCost) ?? 0
        }

        private enum CodingKeys: String, CodingKey {
            case canPickup = "can_pickup"
            case pickupCost = "moves_required"
        }
    }

    private struct PickupResponse: Decodable {
        let message: String?
        let canAttack: Bool?
        let randomHyperGate: Bool?

        private enum CodingKeys: String, CodingKey {
            case message = "pickup_message"
            case canAttack = "can_attack"
            case randomHyperGate = "rhg"
        }
    }
}
