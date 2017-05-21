//
//  ViewController.swift
//  TicTacToe
//
//  Created by Diego Manuel Molina Canedo on 16/1/17.
//  Copyright © 2017 Diego Manuel Molina Canedo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var circulo1: UIImageView!
    
    @IBOutlet weak var circulo2: UIImageView!
    
    @IBOutlet weak var circulo3: UIImageView!
    
    @IBOutlet weak var cruz1: UIImageView!
    
    @IBOutlet weak var cruz2: UIImageView!
    
    @IBOutlet weak var cruz3: UIImageView!
    
    @IBOutlet weak var tablero: UIImageView!
    
    var cruces:[UIImageView] = []
    var circulos:[UIImageView] = []
    
    //Variables de control
    var turnoJugadorUno = true
    var posicionInicial: CGPoint?
    var filaInicial = -1
    var columnaInicial = -1
    
    //Funcionamiento general
    
    var modelo = ModeloTicTacToe()
    var posicionesIniciales:[CGPoint] = []
    var timer:Timer?
    var opacidadFondoFichas:CGFloat = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        posicionesIniciales = [circulo1.center,circulo2.center,circulo3.center,cruz1.center,cruz2.center,cruz3.center]
        circulos = [circulo1,circulo2,circulo3]
        cruces = [cruz1,cruz2,cruz3]
        deshabilitarFichas()
       
        timer = Timer.scheduledTimer(timeInterval: 0.20, target: self, selector: #selector(self.animarFichas(timer:)), userInfo: nil, repeats: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reiniciarJuego() {
        resetearTablero()
    }
    @IBAction func showInfo() {
        guard let url = URL.init(string: "https://en.wikipedia.org/wiki/Tic-tac-toe") else{
        print("URL invalido")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func panHandler(_ sender: UIPanGestureRecognizer) {

        //Mover imagen
        sender.view!.center.x = sender.view!.center.x + sender.translation(in: view).x
        sender.view!.center.y = sender.view!.center.y + sender.translation(in: view).y
        sender.setTranslation(CGPoint.zero, in: view)
        
        if sender.state == .began{
            //guardamos en que posición del tablero está la ficha que estamos moviendo al iniciar el pan
            posicionInicial = sender.view!.center
            (filaInicial,columnaInicial) = obtenerPosicionEnElTablero(posicion: posicionInicial!)
            
        }
        else if sender.state == .ended{
            let (filaFinal,columnaFinal) = obtenerPosicionEnElTablero(posicion: sender.view!.center)
            
            //Comprobamos que la ficha selecciona una posición no ocupada del tablero
        
            if filaFinal != -1 && columnaFinal != -1 && !modelo.ocupada(fila: filaFinal, columna: columnaFinal){
                
                //Comprobamos que la posición inicial fuera una del tablero
                if filaInicial != -1 && columnaInicial != -1{
                    //Quitamos la ficha del modelo
                    modelo.quitarFicha(fila: filaInicial, columna: columnaInicial)
                }
                //Actualizo el tablero
                modelo.colocarFicha(fila: filaFinal, columna: columnaFinal, turno: turnoJugadorUno)
                sender.view!.center = calcularPuntoCentralCasilla(fila: filaFinal, columna: columnaFinal)
                
                //Compruebo si hay 3 en raya
                if(modelo.hayGanador()){
                    informarVictoria()
                }
                
                
                //Cambio de turno
                turnoJugadorUno = !turnoJugadorUno
                
                //Deshabilitar las fichas del jugador que no tiene turno
                deshabilitarFichas()
                modelo.imprimirTablero()
            }
            else{
                //Devolvemos la ficha a su posición inicial
                sender.view!.center = posicionInicial!
                
            }
            
        }
    }
    
    func  obtenerPosicionEnElTablero(posicion: CGPoint) -> (Int,Int){
        //Obtiene la fila y columna en funcion de la posicion donde esté el punto recibido, si no es valida devuele -1-1
        let posicionInicialTablero = tablero.frame.origin
        let saltoX = self.tablero.frame.width / 3
        let saltoY = self.tablero.frame.height / 3
        var fila = -1
        var columna = -1
        
        //BuscarColumna
        if posicion.x > posicionInicialTablero.x && posicion.x < posicionInicialTablero.x+saltoX{
            columna = 0
        }
        else if posicion.x > posicionInicialTablero.x && posicion.x < posicionInicialTablero.x+(2*saltoX){
            columna = 1
        }
        else if posicion.x > posicionInicialTablero.x && posicion.x < posicionInicialTablero.x+(3*saltoX){
            columna = 2
        }
        //BuscarFila
        if posicion.y > posicionInicialTablero.y && posicion.y < posicionInicialTablero.y+saltoY{
            fila = 0
        }
        else if posicion.y > posicionInicialTablero.y && posicion.y < posicionInicialTablero.y+(2*saltoY){
            fila = 1
        }
        else if posicion.y > posicionInicialTablero.y && posicion.y < posicionInicialTablero.y+(3*saltoY){
            fila = 2
        }
        return (fila,columna)
    }
    
    func informarVictoria(){
        let alerta = UIAlertController(title: "¡Tenemos ganador!", message: "¿Queréis volver a jugar?", preferredStyle: .alert)
        
        let accionNO = UIAlertAction(title: "NO", style: .cancel,  handler: {(action) in exit(EXIT_SUCCESS)})
        let accionSI = UIAlertAction(title: "SI", style: .default, handler: {(action) in self.resetearTablero()})
        alerta.addAction(accionNO)
        alerta.addAction(accionSI)
        present(alerta, animated: true, completion: nil)
    }
    
    func deshabilitarFichas(){
        for cruz in cruces{
            cruz.isUserInteractionEnabled = !cruz.isUserInteractionEnabled
            if(!cruz.isUserInteractionEnabled){
                cruz.backgroundColor = UIColor.clear
            }
        }
        for circulo in circulos{
            circulo.isUserInteractionEnabled = !circulo.isUserInteractionEnabled
            if(!circulo.isUserInteractionEnabled){
                circulo.backgroundColor = UIColor.clear
            }
            
        }
    }
    
    func resetearTablero(){
        
        modelo = ModeloTicTacToe()
        
        circulo1.center = posicionesIniciales[0]
        circulo2.center = posicionesIniciales[1]
        circulo3.center = posicionesIniciales[2]
        cruz1.center = posicionesIniciales[3]
        cruz1.center = posicionesIniciales[4]
        cruz1.center = posicionesIniciales[5]
        
        //Puesto que todas están puestas sobre este
        circulo3.setNeedsUpdateConstraints()
        
    }
    
    func animarFichas(timer: Timer){
        if(turnoJugadorUno){
            for circulo in circulos{
                circulo.backgroundColor = UIColor.init(red: 0.1, green: 0.8, blue: 0.2, alpha: opacidadFondoFichas)
            }
        }
        else{
            for cruz in cruces{
                cruz.backgroundColor = UIColor.init(red: 0.1, green: 0.5, blue: 0.5, alpha: opacidadFondoFichas)
            }
        }
        opacidadFondoFichas -= 0.1
        if(opacidadFondoFichas < 0.1){
            opacidadFondoFichas = 0.7
        }
    }
    
    func calcularPuntoCentralCasilla(fila: Int, columna: Int) -> CGPoint{
        
        var punto = tablero.frame.origin
        punto.x += tablero.frame.width/6
        punto.y += tablero.frame.height/6
        
        let tercio = tablero.frame.width/3
        
        punto.x += CGFloat.init(columna) * tercio
        punto.y += CGFloat.init(fila) * tercio
        return punto
    }
    
    


}

