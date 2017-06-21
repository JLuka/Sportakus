//
//  PushToNextController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation


/**
 Extension, des InterfaceControllers DurchführungInterfaceController
 Enthält die Funktionen:
    - zielErreicht
    - resetTraining
 */
extension DurchfuehrungInterfaceController{
    
    /**
     Funktion um zur nächsten View zu wechseln (Uebersicht)
     # Wichtig #
     beendent den Timer zum zählen der gebrauchten Zeit
     ruft resetTraining auf
     setzt boolean viewContentWurdeSchonGeladen auf false
     pusht zum nächsten Controller und übergibt die erreichten Leistungen:
        - Uebungsname
        - Wiederholungen
        - Satz
        - gebrauchte Zeit
        - zu erreichende Sätze
        - Gewicht
     */
    func zielErreicht(){
        neededTime.invalidate()
        let erreichteLeistungen = [self.uebungsName, String(self.wiederholung), String(self.satz), String(self.time), String(self.zuErreichendeSaetze), String(self.gewicht)]
        resetTraining()
        viewContentWurdeSchonGeladen = false
        pushController(withName: "Uebersicht", context: erreichteLeistungen)
    }
    
    /**
     Setzt das gemachte Training zurück
        - timeCounter wieder auf UrsprungsZeit
        - gebrauchte Zeit auf 0
        - wiederholungen auf 0
        - Start Label auf "Start" und enabled diesen Button
     */
    func resetTraining(){
        timeCounter = 5
        time = 0
        wiederholung = 0
        startLabel.setTitle("Start")
        startLabel.setEnabled(true)
    }
}
