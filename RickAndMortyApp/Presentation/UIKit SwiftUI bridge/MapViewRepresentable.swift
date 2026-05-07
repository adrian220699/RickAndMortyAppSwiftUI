//
//  MapViewRepresentable.swift
//  RickAndMortyApp
//
//  Created by Adrian Flores Herrera on 5/6/26.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

    let characters: [Character]

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        return map
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {

        mapView.removeAnnotations(mapView.annotations)

        for character in characters {

            guard let location = character.location else { continue }

            let annotation = MKPointAnnotation()
            annotation.title = character.name
            annotation.subtitle = location.name
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            )

            mapView.addAnnotation(annotation)
        }

        if let first = characters.first,
           let location = first.location {

            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
            )

            mapView.setRegion(region, animated: true)
        }
    }
}
