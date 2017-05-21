//
//  ModeloTicTacToe.swift
//  TicTacToe
//
//  Created by Diego Manuel Molina Canedo on 17/1/17.
//  Copyright © 2017 Diego Manuel Molina Canedo. All rights reserved.
//

import Foundation

class ModeloTicTacToe{
    var tablero = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]]

    func ocupada(fila: Int,columna: Int) -> Bool{
        if(tablero[fila][columna]>0){
            return true
        }
        return false
    }
    
    func quitarFicha(fila: Int, columna: Int){
        tablero[fila][columna] = -1
    }
    
    func colocarFicha(fila: Int, columna: Int, turno: Bool){
        if turno {
            tablero[fila][columna] = 1
        }
        else{
            tablero[fila][columna] = 2
        }
        
    }
    
    func hayGanador() -> Bool{
        if(evaluarFilas() || evaluarColumnas() || evaluarDiagonales()){ return true }
        return false
    }
    
    func evaluarFilas() -> Bool{
        if( (tablero[0][0] == tablero[0][1]) && (tablero[0][0] == tablero[0][2]) && tablero[0][0]>0){ return true }
        if( (tablero[1][0] == tablero[1][1]) && (tablero[1][0] == tablero[1][2]) && tablero[1][0]>0){ return true }
        if( (tablero[2][0] == tablero[2][1]) && (tablero[2][0] == tablero[2][2]) && tablero[2][0]>0){ return true }
        return false
    }
    
    func evaluarColumnas() -> Bool{
        if( (tablero[0][0] == tablero[1][0]) && (tablero[0][0] == tablero[2][0]) && tablero[0][0]>0){ return true }
        if( (tablero[0][1] == tablero[1][1]) && (tablero[0][1] == tablero[2][1]) && tablero[0][1]>0){ return true }
        if( (tablero[0][2] == tablero[1][2]) && (tablero[0][2] == tablero[2][2]) && tablero[0][2]>0){ return true }
        return false
    }
    
    func evaluarDiagonales() -> Bool{
        if( (tablero[0][0] == tablero[1][1]) && (tablero[0][0] == tablero[2][2]) && tablero[0][0]>0){ return true }
        if( (tablero[0][2] == tablero[1][1]) && (tablero[0][2] == tablero[2][0]) && tablero[0][2]>0){ return true }
        return false
    }
    
    func imprimirTablero(){
        print("------------")
        print(self.tablero[0])
        print(self.tablero[1])
        print(self.tablero[2])
        print("------------")
    }

}
