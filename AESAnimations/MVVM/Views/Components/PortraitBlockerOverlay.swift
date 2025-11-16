//
//  AppDelegate.swift
//  AES-Visualization
//
//  Created by Leon Chamoun on 16.11.25.
//

#if os(iOS)
import SwiftUI


enum DeviceOrientation {
    case portrait
    case landscape
    case unknown
}

class OrientationManager: ObservableObject {
    @Published var orientation: DeviceOrientation = .unknown
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.updateOrientation()
        }
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        updateOrientation()
    }
    
    private func updateOrientation() {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            orientation = .portrait
        case .landscapeLeft, .landscapeRight:
            orientation = .landscape
        default:
            orientation = .unknown
        }
    }
}

struct PortraitBlockerOverlay: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "ipad.landscape")
                    .font(.system(size: 70))
                    .foregroundColor(.pink)
                
                Text("Bitte drehe dein Gerät ins Querformat.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}
#endif
