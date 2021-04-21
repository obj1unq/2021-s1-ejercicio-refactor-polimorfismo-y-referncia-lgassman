/*
 * Recordá que:
 *  ```
 *    var property x
 *  ``` 
 * 
 * es equivalente a escribir:
 * 
 *  ```
 *   var x
 *   method x() { return x }
 *   method x(_x) { x = _x}
 * ```
 * 
 */

object virtuoso {
	var property instrumento = guitarraElectrica
	
	method suenaLindo() {
		return true 
	}
	
	method tocar() {
		//repite 10 veces instrumento.usar(). 
		//En index está el número de iteración aunque no lo usemos.
		10.times ({ index =>
			instrumento.usar()
		})
	}
	
	
}

object principiante {
	var property instrumento = guitarraElectrica
	
	method suenaLindo () {
		 return !instrumento.gastado()
	}

	method tocar() {
		instrumento.usar()
	}
}



object guitarraElectrica {
	var property equipo = equipoChico
	
	method usar() {
		equipo.usar()
	}
	
	method gastado() {
		return equipo.gastado()
	}
	
}

object guitarraElectroAcustica {
	var property equipo = equipoChico
	var property usado = false
	
	method usar() {
		if( ! equipo.gastado()) { 
			usado = true
			equipo.usar()
		}
	}
	
	method gastado() {
		return usado
	}
	
}

object equipoChico {
	
	const usosMaximos = 6
	var usos = 0
	
	method usar() {
		usos = ( usos + 1).min(usosMaximos)
	}
	
	method gastado() {
		return usos == usosMaximos
	}
	
}

object zapato {
	
	method gastado() {
		return true
	}
}




