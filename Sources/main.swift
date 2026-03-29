// The Swift Programming Language
// https://docs.swift.org/swift-book

import AppKit
import SceneKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var sceneView: SCNView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screenSize = NSScreen.main?.frame.size ?? .init(width: 1280, height: 720)

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: screenSize.width * 0.7, height: screenSize.height * 0.7),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Apexean U 3D"

        let contentView = NSView(frame: window.contentView!.bounds)
        contentView.autoresizingMask = [.width, .height]
        window.contentView = contentView

        // Toolbar area (top)
        let toolbarHeight: CGFloat = 40
        let toolbarView = NSView(frame: NSRect(x: 0,
                                               y: contentView.bounds.height - toolbarHeight,
                                               width: contentView.bounds.width,
                                               height: toolbarHeight))
        toolbarView.autoresizingMask = [.width, .minYMargin]
        contentView.addSubview(toolbarView)

        // 3D viewport
        let viewportFrame = NSRect(x: 0,
                                   y: 0,
                                   width: contentView.bounds.width,
                                   height: contentView.bounds.height - toolbarHeight)
        sceneView = SCNView(frame: viewportFrame)
        sceneView.autoresizingMask = [.width, .height]
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .black
        contentView.addSubview(sceneView)

        setupScene()

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
    private func setupScene() {
        let scene = SCNScene()

        // Simple test object: a cube
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.05)
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(boxNode)

        // Light
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(lightNode)

        // Camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 8)
        scene.rootNode.addChildNode(cameraNode)

        sceneView.scene = scene
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
