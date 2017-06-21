//
//  TableRowController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//



import WatchKit
/**
 NSObject Klasse mit zwei variablen, die jeweils eine Verbindung zu einer View haben
 - label -> Table in der View Plaene
 - uebungenLabel -> Table in der View Uebungen
 */
class TableRowController: NSObject {
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var uebungenLabel: WKInterfaceLabel!
}
