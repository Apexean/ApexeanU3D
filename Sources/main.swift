// The Swift Programming Language
// https://docs.swift.org/swift-book

import AppKit
import SceneKit

final class StartMenuView: NSView {
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let title = NSTextField(labelWithString: "Apexean U 3D")
        title.font = NSFont.systemFont(ofSize: 32, weight: .bold)
        title.alignment = .center
        title.frame = NSRect(x: 0, y: bounds.height - 120, width: bounds.width, height: 50)
        title.autoresizingMask = [.width, .minYMargin]
        addSubview(title)

        let newButton = makeButton("New Project", action: #selector(newProject))
        newButton.frame.origin = CGPoint(x: bounds.midX - 100, y: bounds.midY + 20)
        addSubview(newButton)

        let importButton = makeButton("Import Model", action: #selector(importModel))
        importButton.frame.origin = CGPoint(x: bounds.midX - 100, y: bounds.midY - 40)
        addSubview(importButton)
    }

    private func makeButton(_ title: String, action: Selector) -> NSButton {
        let btn = NSButton(title: title, target: self, action: action)
        btn.setButtonType(.momentaryPushIn)
        btn.bezelStyle = .rounded
        btn.frame.size = CGSize(width: 200, height: 40)
        return btn
    }

    @objc private func newProject() {
        NotificationCenter.default.post(name: .startNewProject, object: nil)
    }

    @objc private func importModel() {
        NotificationCenter.default.post(name: .importModel, object: nil)
    }
}

extension Notification.Name {
    static let startNewProject = Notification.Name("startNewProject")
    static let importModel = Notification.Name("importModel")
}

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
