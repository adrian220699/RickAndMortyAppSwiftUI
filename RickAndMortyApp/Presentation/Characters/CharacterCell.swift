//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/5/26.
//

import UIKit
import SwiftUI

final class CharacterCell: UITableViewCell {

    static let identifier = "CharacterCell"

    private var host: UIHostingController<CharacterRowView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        host?.view.removeFromSuperview()
        host = nil
    }

    func configure(with character: Character) {

        // Si ya existe, lo removemos
        host?.view.removeFromSuperview()

        let swiftUIView = CharacterRowView(character: character)
        let hostController = UIHostingController(rootView: swiftUIView)

        host = hostController

        guard let view = hostController.view else { return }

        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
