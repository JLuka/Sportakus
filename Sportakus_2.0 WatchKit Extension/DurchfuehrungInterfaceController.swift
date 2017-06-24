//
//  DurchfuehrungInterfaceController.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 02.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

/**
 InterfaceController zur View "Durchfuehrung"
 Die View zeigt alle Informationen zur Uebung an, die ausgeführt wird
 Der Controller startet das Training und zählt die Wiederholungen an
 */
class DurchfuehrungInterfaceController: WKInterfaceController {
    
    /**
     Outlets für die Labels in der View
     */
    @IBOutlet var uebungsNameLabel: WKInterfaceLabel!
    @IBOutlet var gewichtLabel: WKInterfaceLabel!
    @IBOutlet var saetzeLabel: WKInterfaceLabel!
    @IBOutlet var startLabel: WKInterfaceButton!
    @IBOutlet var wiederholungenLabel: WKInterfaceLabel!
    @IBOutlet var stopButton: WKInterfaceButton!
    
    //Uebergebene Werte
    var uebung = [String]()
    var uebungsName = String()
    var gewicht = Double()
    var zuErreichendeSaetze = Int()
    var zuErreichendeWiederholungen = Int()
    
    //Variable Werte
    var wiederholung = 0
    var satz = 0
    var started = false
    var repTimerCounter = 0
    var lifted = false
    
    //Timer
    var countDownToStartExercise = Timer()
    var neededTime = Timer()
    var timeCounter = 5
    var time = 0
    var repTimer = Timer()
    
    //Motion Handler
    var motionManager = CMMotionManager()
    
    var viewContentWurdeSchonGeladen = false
    
    /**
     Speichert übergebenen Context (ausgewählte Uebung und ihre Werte) in der Variable "uebung"
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        uebung = context as! [String]
    }
    
    /**
     Ruft fillViewWithContent auf, wenn dieser Content im aktuellen Satz noch nicht geladen wurde
     */
    override func willActivate() {
        super.willActivate()
        if viewContentWurdeSchonGeladen == false {
            fillViewWithContent()
        }
    }
    
    /**
     Stoppt den Updater der Device Motions, wenn die View deaktiviert wird
     */
    override func didDeactivate() {
        super.didDeactivate()
        motionManager.stopDeviceMotionUpdates()
    }

    /**
     - Füllt die View mit dem übergebenen Content.
     - Zählt den aktuellen Satz einen hoch
     - Wenn das Gewicht 0 beträgt, wird das Gewichtslabel auf EG (Eigengewicht) gesetzt
     - setzt die Variable viewContentWurdeSchonGeladen auf true
     */
    func fillViewWithContent(){
        uebungsName = uebung[0]
        gewicht = Double(uebung[1])!
        zuErreichendeSaetze = Int(uebung[2])!
        zuErreichendeWiederholungen = Int(uebung[3])!
        
        uebungsNameLabel.setText(uebungsName)
        stopButton.setEnabled(false)
        
        if gewicht == 0 {
            gewichtLabel.setText("EG")
        }else{
            gewichtLabel.setText(String(gewicht) + "kg")
        }
        satz += 1
        startLabel.setTitle("Start")
        saetzeLabel.setText(String(satz))
        wiederholungenLabel.setText(String(zuErreichendeWiederholungen))
        viewContentWurdeSchonGeladen = true
    }

    /**
     Wird ausgeführt, wenn der Startbutton gedrückt wurde
     Disabled den StartButton
     startet den Countdown bis zum Start 
     
     # Wichtig #
     Der Countdown ruft in einem Intervall von einer Sekunde die Methode timerAction auf
     */
    @IBAction func startButtonPressed() {
        startLabel.setTitle("Bereit?")
        countDownToStartExercise.invalidate()
        startLabel.setEnabled(false)
        if timeCounter > 2 {
            countDownToStartExercise = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            startLabel.setEnabled(false)
        }
    }
    
    /**
     Zählt den timeCounter einen herunter, wenn der timeCounter größer als 0 ist
     Zeigt jede Sekunde ein neues Wort oder Zahlen an.
     
     # Timerablauf #
     - Bereit
     - Start in:
     - 3
     - 2
     - 1
     - 0
     Countdown wird beendet und countRepititions wird aufgerufen
     */
    func timerAction() {
        if timeCounter > 0 {
            timeCounter -= 1
            if timeCounter == 4 {
                startLabel.setTitle("Start in:")
            }else if timeCounter == 0{
                startLabel.setTitle(String(wiederholung))
            }else {
                startLabel.setTitle("\(timeCounter)")
            }
            
            saetzeLabel.setText("\(satz)")
        }else{
            countDownToStartExercise.invalidate()
            WKInterfaceDevice.current().play(.click)
            countRepititions()
        }
    }
    
    /**
     Methode, die den Uebungsnamen überprüft und zur dementsprechenden Extension weiterleitet
     */
    func countRepititions(){
        timerStarten()
        countReps()
    }
    
    /**
     Methode um die Wiederholungen eine Hochzuzählen und den Stop Button zu enablen, wenn die Wiederholung größer als 0 ist.
     */
    func increaseReps(){
        self.wiederholung += 1
        if wiederholung > 0 {
            stopButton.setEnabled(true)
        }
    }
    
    /**
     Wenn der Stop Button gedrückt wird, wird zielErreicht aufgerufen
     */
    @IBAction func stopButtonPressed() {
        zielErreicht()
    }
    
    /**
     Wird ausgelöst, wenn der Testbutton geklickt wird.
     Muss noch gelöscht werden, wenn ausreichend Extensions zum tracken der Wiederholungen eingebaut sind.
     Ruft increaseReps auf und setzt das Wiederholungen Label mit der neunen Anzahl an gemachten Wiederholungen
     Ruft zielErreicht auf, wenn das angestrebte Ziel erreicht wurde (wiederholungen = zuErreichendeWiederholungen)
     */
    @IBAction func testButtonPressed() {
        increaseReps()
        startLabel.setTitle(String(wiederholung))
        if wiederholung == zuErreichendeWiederholungen {
            zielErreicht()
        }
    }
}
