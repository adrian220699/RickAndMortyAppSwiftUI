//
//  CharacterMapViewController.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//


import UIKit
import MapKit
import SwiftUI

final class CharacterMapViewController: UIViewController {

    private let characters: [Character]

    init(characters: [Character]) {
        self.characters = characters
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = CharacterMapSwiftUIView(characters: characters)
        let host = UIHostingController(rootView: swiftUIView)

        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)

        host.view.frame = view.bounds
    }
}
