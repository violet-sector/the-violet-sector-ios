// Created by João Santos for project The Violet Sector.

import SwiftUI

struct Map: View {
    @ObservedObject private var model = Model<Data>(resource: "navcom_map.php")
    @State private var selectedSector: Sectors?

    var body: some View {
        VStack() {
            if model.data != nil {
                ScrollableMap(data: model.data!, selectedSector: $selectedSector)
                if selectedSector != nil {
                    NavigationLink(destination: SectorDetails(sector: selectedSector!, legions: model.data!.domination[selectedSector!] ?? []), tag: selectedSector!, selection: $selectedSector, label: {EmptyView()})
                        .hidden()
                }
            } else if model.error != nil {
                FriendlyError(error: model.error!)
            } else {
                Loading()
            }
            Status(data: model.data?.status)
        }
    }

    private struct Data: Decodable {
        let domination: [Sectors: Set<Legions>]
        let gates: Set<Sectors>
        let status: Status.Data

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let decodedDomination = try container.decode([String: Set<Legions>].self, forKey: .domination)
            var domination = [Sectors: Set<Legions>]()
            domination.reserveCapacity(domination.count)
            for (key: key, value: value) in decodedDomination {
                guard let convertedKey = UInt(key) else {
                    continue
                }
                guard let sector = Sectors(rawValue: convertedKey) else {
                    continue
                }
                domination[sector] = value
            }
            self.domination = domination
            gates = try container.decode(Set<Sectors>.self, forKey: .gates)
            status = try container.decode(Status.Data.self, forKey: .status)
        }

        private enum CodingKeys: String, CodingKey {
            case domination = "domination_info"
            case gates = "destinations"
            case status = "player"
        }
    }

    private struct ScrollableMap: UIViewRepresentable {
        let data: Data
        @Binding var selectedSector: Sectors?

        func makeUIView(context: Context) -> UIScrollView {
            let imageView = makeInteractiveMap(coordinator: context.coordinator)
            let scrollView = ScrollView()
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
            scrollView.scrollsToTop = false
            return scrollView
        }

        func updateUIView(_: UIScrollView, context _: Context) {}

        func makeCoordinator() -> Coordinator {
            return Coordinator(handler: {self.selectedSector = $0})
        }

        private func makeInteractiveMap(coordinator: Coordinator) -> UIImageView {
            let image = drawMap()
            let imageView = UIImageView(image: image)
            var elements = [Any]()
            elements.reserveCapacity(Int(Sectors.uncharted.rawValue - Sectors.none.rawValue))
            for sectorValue in Sectors.home1.rawValue...Sectors.uncharted.rawValue {
                guard Client.shared.settings!.isOuterRimEnabled || !(Sectors.outer1.rawValue...Sectors.outer8.rawValue ~= sectorValue) else {
                    continue
                }
                let sector = Sectors(rawValue: sectorValue)!
                guard sector != .uncharted || data.status.currentSector == .uncharted || data.status.destinationSector == .uncharted || data.gates.contains(.uncharted) || data.domination[.uncharted] != nil else {
                    continue
                }
                let coordinates = sector.coordinates
                let element = AccessibilityElement(accessibilityContainer: imageView)
                element.sector = sector
                if sector != .asteroids {
                    element.accessibilityFrameInContainerSpace = CGRect(x: coordinates.x - 20.0, y: coordinates.y - 20.0, width: 40.0, height: 40.0)
                } else {
                    element.accessibilityFrameInContainerSpace = CGRect(x: coordinates.x - 75.0, y: coordinates.y - 43.0, width: 150.0, height: 86.0)
                }
                element.accessibilityLabel = "\(sector)."
                if let legions = data.domination[sector] {
                    if legions.count == 1 {
                        element.accessibilityHint = " Dominated by \(legions.first!)s."
                    } else {
                        element.accessibilityHint = " Contested by "
                        let legions = legions.sorted(by: {$0.rawValue < $1.rawValue})
                        if legions.count == 2 {
                            element.accessibilityHint! += "\(legions.first!)s and \(legions.last!)s."
                        } else {
                            for legion in legions {
                                if legion != legions.last! {
                                    element.accessibilityHint! += "\(legion)s, "
                                } else {
                                    element.accessibilityHint! += "and \(legion)s."
                                }
                            }
                        }
                    }
                }
                if data.gates.contains(sector) {
                    element.accessibilityHint = element.accessibilityHint != nil ? element.accessibilityHint! + " You can hyper to this sector." : "You can hyper to this sector."
                }
                if sector == data.status.currentSector && data.status.destinationSector == .none {
                    element.accessibilityHint = element.accessibilityHint != nil ? element.accessibilityHint! + " You are currently in this sector." : "You are currently in this sector."
                }
                if sector == data.status.destinationSector {
                    element.accessibilityHint = element.accessibilityHint != nil ? element.accessibilityHint! + " You are hypering to this sector." : "You are hypering to this sector."
                }
                elements.append(element)
            }
            imageView.accessibilityElements = elements
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(coordinator.gestureRecognizer)
            if !data.gates.isEmpty {
                let hyperRotor = UIAccessibilityCustomRotor(name: "Available hypergates") {(predicate) in
                    let element = predicate.currentItem.targetElement as! AccessibilityElement
                    let sector = element.sector
                    let openGates = self.data.gates.sorted(by: {$0.rawValue < $1.rawValue})
                    if predicate.searchDirection == .next {
                        let index = openGates.firstIndex(where: {$0.rawValue > sector.rawValue}) ?? 0
                        let sector = openGates[index]
                        let elementIndex = imageView.accessibilityElements!.firstIndex(where: {($0 as! AccessibilityElement).sector == sector}) ?? 0
                        let element = imageView.accessibilityElements![elementIndex] as! AccessibilityElement
                        return UIAccessibilityCustomRotorItemResult(targetElement: element, targetRange: nil)
                    } else {
                        let index = openGates.lastIndex(where: {$0.rawValue < sector.rawValue}) ?? openGates.count - 1
                        let sector = openGates[index]
                        let elementIndex = imageView.accessibilityElements!.firstIndex(where: {($0 as! AccessibilityElement).sector == sector}) ?? 0
                        let element = imageView.accessibilityElements![elementIndex] as! AccessibilityElement
                        return UIAccessibilityCustomRotorItemResult(targetElement: element, targetRange: nil)
                    }
                }
                imageView.accessibilityCustomRotors = [hyperRotor]
            }
            return imageView
        }

        private func drawMap() -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 510.0, height: 675.0))
            return renderer.image() {(_) in
                UIColor.black.setFill()
                let backgroundPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: 510.0, height: 675.0))
                backgroundPath.fill()
                self.drawGates()
                self.drawPlayerLocation()
                self.drawOpenGates()
                self.drawEmptySectors()
                self.drawDominatedSectors()
                self.drawContestedSectors()
                self.drawHyperArrow()
                self.drawSectorLabels()
            }
        }

        private func drawGates() {
            UIColor.white.setStroke()
            UIColor.black.setFill()
            if Client.shared.settings!.isOuterRimEnabled {
                let outerGatesPath = UIBezierPath(ovalIn: CGRect(x: Sectors.outer7.coordinates.x, y: Sectors.outer1.coordinates.y, width: Sectors.outer3.coordinates.x - Sectors.outer7.coordinates.x, height: Sectors.outer5.coordinates.y - Sectors.outer1.coordinates.y))
                for sectorValue in ClosedRange(uncheckedBounds: (lower: Sectors.outer1.rawValue, upper: Sectors.outer4.rawValue)) {
                    outerGatesPath.move(to: Sectors(rawValue: sectorValue)!.coordinates)
                    outerGatesPath.addLine(to: Sectors(rawValue: sectorValue + 4)!.coordinates)
                }
                outerGatesPath.stroke()
            }
            let innerGatesPath = UIBezierPath(ovalIn: CGRect(x: Sectors.home4.coordinates.x, y: Sectors.home1.coordinates.y, width: Sectors.home2.coordinates.x - Sectors.home4.coordinates.x, height: Sectors.home3.coordinates.y - Sectors.home1.coordinates.y))
            for sectorValue in ClosedRange(uncheckedBounds: (lower: Sectors.giant1.rawValue, upper: Sectors.giant4.rawValue)) {
                innerGatesPath.move(to: Sectors(rawValue: sectorValue)!.coordinates)
                innerGatesPath.addLine(to: Sectors(rawValue: sectorValue + 4)!.coordinates)
            }
            innerGatesPath.fill()
            innerGatesPath.stroke()
            let violetSectorGates = UIBezierPath(rect: CGRect(x: Sectors.violet.coordinates.x - 42.0, y: Sectors.violet.coordinates.y - 42.0, width: 84.0, height: 84.0))
            violetSectorGates.move(to: CGPoint(x: Sectors.violet.coordinates.x - 42.0, y: Sectors.violet.coordinates.y))
            violetSectorGates.addLine(to: CGPoint(x: Sectors.violet.coordinates.x + 42.0, y: Sectors.violet.coordinates.y))
            violetSectorGates.move(to: Sectors.quadrant2.coordinates)
            violetSectorGates.addLine(to: CGPoint(x: Sectors.quadrant2.coordinates.x + 42.0, y: Sectors.quadrant2.coordinates.y))
            violetSectorGates.move(to: Sectors.quadrant4.coordinates)
            violetSectorGates.addLine(to: CGPoint(x: Sectors.quadrant4.coordinates.x - 42.0, y: Sectors.quadrant4.coordinates.y))
            violetSectorGates.stroke()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let font = UIFont(name: "Arial", size: 8.0)!
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let leftGateLabel = "To \(Sectors.quadrant2)" as NSString
            leftGateLabel.draw(with: CGRect(x: Sectors.violet.coordinates.x - 42.0, y: Sectors.violet.coordinates.y, width: 27.0, height: 16.0), options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
            let rightGateLabel = "To \(Sectors.quadrant4)" as NSString
            rightGateLabel.draw(with: CGRect(x: Sectors.violet.coordinates.x + 15.0, y: Sectors.violet.coordinates.y, width: 27.0, height: 16.0), options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
            let violetGateLabel = "To \(Sectors.violet)" as NSString
            var violetGateLabelRect = violetGateLabel.boundingRect(with: CGSize(width: 50.0, height: 64.0), options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
            violetGateLabelRect = CGRect(x: Sectors.quadrant2.coordinates.x + 42.0, y: Sectors.quadrant2.coordinates.y - violetGateLabelRect.size.height / 2.0, width: violetGateLabelRect.size.width, height: violetGateLabelRect.size.height)
            violetGateLabel.draw(with: violetGateLabelRect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
            violetGateLabelRect = CGRect(x: Sectors.quadrant4.coordinates.x - 42.0 - violetGateLabelRect.size.width, y: Sectors.quadrant4.coordinates.y - violetGateLabelRect.size.height / 2.0, width: violetGateLabelRect.size.width, height: violetGateLabelRect.size.height)
            violetGateLabel.draw(with: violetGateLabelRect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        }

        private func drawEmptySectors() {
            for sectorValue in Sectors.home1.rawValue...Sectors.violet.rawValue {
                guard Client.shared.settings!.isOuterRimEnabled || !(Sectors.outer1.rawValue...Sectors.outer8.rawValue ~= sectorValue) else {
                    continue
                }
                let sector = Sectors(rawValue: sectorValue)!
                if data.domination[sector] == nil {
                    drawSolidSector(color: UIColor.white, sector: sector)
                }
            }
            if (data.status.currentSector == .uncharted || data.status.destinationSector == .uncharted || data.gates.contains(.uncharted)) && data.domination[.uncharted] == nil {
                drawSolidSector(color: UIColor.white, sector: .uncharted)
            }
        }

        private func drawDominatedSectors() {
            for (key: sector, value: legions) in data.domination {
                guard legions.count == 1 else {
                    continue
                }
                let legion = legions.first!
                drawSolidSector(color: UIColor(named: "\(legion)") ?? UIColor.white, sector: sector)
            }
        }

        private func drawContestedSectors() {
            for (key: sector, value: legions) in data.domination {
                let legions = legions.sorted(by: {$0.rawValue < $1.rawValue})
                var angle = CGFloat.pi / 2.0
                let angleIncrement = -CGFloat.pi * 2.0 / CGFloat(legions.count)
                var point = CGPoint(x: 0, y: 15.0)
                let coordinates = sector.coordinates
                let rotation = CGAffineTransform(rotationAngle: angleIncrement)
                let translation = CGAffineTransform(translationX: coordinates.x, y: coordinates.y)
                for legion in legions {
                    let color = UIColor(named: "\(legion)") ?? UIColor.white
                    color.setFill()
                    let slicePath = UIBezierPath()
                    slicePath.move(to: CGPoint(x: 0.0, y: 0.0))
                    slicePath.addLine(to: point)
                    slicePath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: 15.0, startAngle: angle, endAngle: angle + angleIncrement, clockwise: true)
                    slicePath.close()
                    if sector == .asteroids {
                        let scale = CGAffineTransform(scaleX: 150.0 / 30.0, y: 86.0 / 30.0)
                        slicePath.apply(scale)
                    }
                    slicePath.apply(translation)
                    slicePath.fill()
                    point = point.applying(rotation)
                    angle += angleIncrement
                }
            }
        }

        private func drawPlayerLocation() {
            UIColor.red.setStroke()
            let sector = data.status.currentSector
            var rect = CGRect(x: sector.coordinates.x - 20.0, y: sector.coordinates.y - 20.0, width: 40.0, height: 40.0)
            if sector == .asteroids {
                rect = CGRect(x: sector.coordinates.x - 80.0, y: sector.coordinates.y - 48.0, width: 160.0, height: 96.0)
            }
            let playerLocationPath = UIBezierPath(ovalIn: rect)
            playerLocationPath.lineWidth = 3.0
            playerLocationPath.stroke()
        }

        private func drawOpenGates() {
            UIColor.blue.setStroke()
            for sector in data.gates {
                var rect = CGRect(x: sector.coordinates.x - 20.0, y: sector.coordinates.y - 20.0, width: 40.0, height: 40.0)
                if sector == .asteroids {
                    rect = CGRect(x: sector.coordinates.x - 80.0, y: sector.coordinates.y - 48.0, width: 160.0, height: 96.0)
                }
                let openGatePath = UIBezierPath(ovalIn: rect)
                openGatePath.lineWidth = 3.0
                openGatePath.stroke()
            }
        }

        private func drawHyperArrow() {
            guard data.status.destinationSector != .none else {
                return
            }
            var origin = data.status.currentSector.coordinates
            var destination = data.status.destinationSector.coordinates
            var difference = CGPoint(x: destination.x - origin.x, y: destination.y - origin.y)
            var distance = (difference.x * difference.x + difference.y * difference.y).squareRoot()
            guard distance > 0.0 else {
                return
            }
            let unit = CGPoint(x: difference.x / distance, y: difference.y / distance)
            if data.status.currentSector == .asteroids {
                let slope = CGPoint(x: difference.x, y: difference.y / 43.0 * 75.0)
                let length = (slope.x * slope.x + slope.y * slope.y).squareRoot()
                let unit = CGPoint(x: slope.x / length, y: slope.y / length)
                origin = CGPoint(x: origin.x + unit.x * 75.0, y: origin.y + unit.y * 43.0)
            } else {
                origin = CGPoint(x: origin.x + unit.x * 15.0, y: origin.y + unit.y * 15.0)
            }
            if data.status.destinationSector == .asteroids {
                let slope = CGPoint(x: difference.x, y: difference.y / 43.0 * 75.0)
                let length = (slope.x * slope.x + slope.y * slope.y).squareRoot()
                let unit = CGPoint(x: slope.x / length, y: slope.y / length)
                destination = CGPoint(x: destination.x - unit.x * 75.0, y: destination.y - unit.y * 43.0)
            } else {
                destination = CGPoint(x: destination.x - unit.x * 15.0, y: destination.y - unit.y * 15.0)
            }
            difference = CGPoint(x: destination.x - origin.x, y: destination.y - origin.y)
            distance = (difference.x * difference.x + difference.y * difference.y).squareRoot()
            UIColor.purple.set()
            let transform = CGAffineTransform(a: unit.x, b: unit.y, c: -unit.y, d: unit.x, tx: destination.x, ty: destination.y)
            let arrowPath = UIBezierPath()
            arrowPath.move(to: CGPoint.zero)
            arrowPath.addLine(to: CGPoint(x: -10.0, y: 5.0))
            arrowPath.addLine(to: CGPoint(x: -8.0, y: 0.0))
            arrowPath.addLine(to: CGPoint(x: -10.0, y: -5.0))
            arrowPath.close()
            arrowPath.apply(transform)
            arrowPath.fill()
            arrowPath.removeAllPoints()
            arrowPath.move(to: CGPoint.zero)
            arrowPath.addLine(to: CGPoint(x: -distance, y: 0.0))
            arrowPath.apply(transform)
            arrowPath.lineWidth = 3.0
            arrowPath.stroke()
        }

        private func drawSectorLabels() {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let font = UIFont(name: "Arial", size: 10.0)!
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.yellow, NSAttributedString.Key.backgroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            for sectorValue in Sectors.home1.rawValue...Sectors.uncharted.rawValue {
                guard Client.shared.settings!.isOuterRimEnabled || !(Sectors.outer1.rawValue...Sectors.outer8.rawValue ~= sectorValue) else {
                    continue
                }
                let sector = Sectors(rawValue: sectorValue)!
                guard sector != .uncharted || data.status.currentSector == .uncharted || data.status.destinationSector == .uncharted || data.gates.contains(.uncharted) || data.domination[.uncharted] != nil else {
                    continue
                }
                let sectorLabel = "\(sector)" as NSString
                var point = CGPoint(x: sector.coordinates.x, y: sector.coordinates.y - 20.0)
                var size = CGSize(width: 60.0, height: 60.0)
                if sector == .asteroids {
                    point = CGPoint(x: sector.coordinates.x, y: sector.coordinates.y - 56.0)
                    size = CGSize(width: 150.0, height: 16.0)
                }
                var rect = sectorLabel.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
                rect = CGRect(origin: CGPoint(x: point.x - rect.size.width / 2.0, y: point.y - rect.size.height), size: rect.size)
                sectorLabel.draw(with: rect, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
            }
        }

        private func drawSolidSector(color: UIColor, sector: Sectors) {
            color.setFill()
            var sectorRect = CGRect(x: sector.coordinates.x - 15.0, y: sector.coordinates.y - 15.0, width: 30.0, height: 30.0)
            if sector == .asteroids {
                sectorRect = CGRect(x: sector.coordinates.x - 75.0, y: sector.coordinates.y - 43.0, width: 150.0, height: 86.0)
            }
            let sectorPath = UIBezierPath(ovalIn: sectorRect)
            sectorPath.fill()
        }

        private final class ScrollView: UIScrollView, UIScrollViewDelegate {
            private var lastSize = CGSize.zero

            override init(frame: CGRect) {
                super.init(frame: frame)
                delegate = self
            }

            required init?(coder: NSCoder) {
                super.init(coder: coder)
                delegate = self
            }

            func viewForZooming(in scrollView: UIScrollView) -> UIView? {
                return scrollView.subviews.first!
            }

            func scrollViewDidZoom(_: UIScrollView) {
                let view = subviews.first!
                let contentCenter = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
                let scrollCenter = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
                let offset = CGPoint(x: view.frame.size.width < bounds.size.width ? contentCenter.x - scrollCenter.x : contentOffset.x, y: view.frame.size.height < bounds.size.height ? contentCenter.y - scrollCenter.y : contentOffset.y)
                contentOffset = offset
            }

            override func layoutSubviews() {
                super.layoutSubviews()
                defer {
                    scrollViewDidZoom(self)
                }
                guard bounds.size != lastSize else {
                    return
                }
                lastSize = bounds.size
                let mapView = self.subviews.first! as! UIImageView
                let mapImage = mapView.image!
                let scale = min(min(bounds.size.width / mapImage.size.width, bounds.size.height / mapImage.size.height), 1.0)
                maximumZoomScale = 1.0
                minimumZoomScale = scale
                setZoomScale(scale, animated: false)
            }
        }

        final class Coordinator: NSObject {
            let handler: (_: Sectors) -> Void
            let gestureRecognizer: UITapGestureRecognizer

            init(handler: @escaping (_: Sectors) -> Void) {
                self.handler = handler
                gestureRecognizer = UITapGestureRecognizer()
                super.init()
                gestureRecognizer.addTarget(self, action: #selector(tap))
            }

            @objc private func tap() {
                for element in gestureRecognizer.view!.accessibilityElements! {
                    let element = element as! AccessibilityElement
                    let rect = element.accessibilityFrameInContainerSpace
                    let point = gestureRecognizer.location(in: gestureRecognizer.view)
                    guard point.x >= rect.origin.x && point.y >= rect.origin.y else {
                        continue
                    }
                    guard point.x - rect.origin.x < rect.size.width && point.y - rect.origin.y < rect.size.height else {
                        continue
                    }
                    handler(element.sector)
                    return
                }
            }
        }

        private final class AccessibilityElement: UIAccessibilityElement {
            var sector = Sectors.none
        }
    }
}

fileprivate extension Sectors {
    var coordinates: CGPoint {
        switch self {
        case .none:
            return CGPoint(x: 255.0, y: 320.0)
        case .home1:
            return CGPoint(x: 255.0, y: 120.0)
        case .home2:
            return CGPoint(x: 405.0, y: 320.0)
        case .home3:
            return CGPoint(x: 255.0, y: 520.0)
        case .home4:
            return CGPoint(x: 105.0, y: 320.0)
        case .giant1:
            return CGPoint(x: 326.0, y: 144.0)
        case .giant2:
            return CGPoint(x: 399.0, y: 262.0)
        case .giant3:
            return CGPoint(x: 399.0, y: 378.0)
        case .giant4:
            return CGPoint(x: 326.0, y: 496.0)
        case .giant5:
            return CGPoint(x: 184.0, y: 496.0)
        case .giant6:
            return CGPoint(x: 111.0, y: 378.0)
        case .giant7:
            return CGPoint(x: 111.0, y: 262.0)
        case .giant8:
            return CGPoint(x: 184.0, y: 144.0)
        case .quadrant1:
            return CGPoint(x: 375.0, y: 200.0)
        case .quadrant2:
            return CGPoint(x: 375.0, y: 440.0)
        case .quadrant3:
            return CGPoint(x: 135.0, y: 440.0)
        case .quadrant4:
            return CGPoint(x: 135.0, y: 200.0)
        case .outer1:
            return CGPoint(x: 255.0, y: 40.0)
        case .outer2:
            return CGPoint(x: 433.0, y: 142.0)
        case .outer3:
            return CGPoint(x: 485.0, y: 320.0)
        case .outer4:
            return CGPoint(x: 433.0, y: 498.0)
        case .outer5:
            return CGPoint(x: 255.0, y: 600.0)
        case .outer6:
            return CGPoint(x: 77.0, y: 498.0)
        case .outer7:
            return CGPoint(x: 25.0, y: 320.0)
        case .outer8:
            return CGPoint(x: 77.0, y: 142.0)
        case .asteroids:
            return CGPoint(x: 255.0, y: 320.0)
        case .violet:
            return CGPoint(x: 457.0, y: 589.0)
        case .uncharted:
            return CGPoint(x: 50.0, y: 50.0)
        }
    }
}
