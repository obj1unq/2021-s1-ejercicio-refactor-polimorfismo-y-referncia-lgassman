object paquete {

	var property cantidadPersonas = 1 // un numero
	var property servicioOfrecido = servicio // hotel, traslado, combinado
	var property premium = false // un booleano 
	var reservado = false

	method estaReservado() {
		return reservado
	}

	// Se puede reservar si no esta reservado y el servicio se puede reservar
	method sePuedeReservar() {
		return not self.estaReservado() and servicioOfrecido.sePuedeReservar(self)
	}

	// Cuando se reserva se cambia el estado y se modifican los lugares 
	// disponibles en los servicios
	method reservar() {
		servicioOfrecido.reservar(self)
		reservado = true
	}

}

object hotel {
	var property camasDisponibles = 30 // camas disponibles del HOTEL
	var property estrellas = 1 // cantidad de estrellas del HOTEL
	var property spaDisponible = true // si el HOTEL tiene spa disponible
	
	method sePuedeReservar(_paquete) {
		// Ademas, si el paquete es premium el hotel tiene que ser
		// como minimo de 4 estrellas
		return self.camasDisponibles() >= _paquete.cantidadPersonas() and 
				(not _paquete.premium() or (self.estrellas() >= 4 and self.spaDisponible())) 
	}
	
	method reservar(_paquete) {
		self.camasDisponibles(self.camasDisponibles() - _paquete.cantidadPersonas())
		if (_paquete.premium()) {
			self.reservarSpa()
		}
	}
	
	method reservarSpa() {
		spaDisponible = false
	}
	
	method configurar(_estrellas, _camas, _spaDisponible) {
		estrellas = _estrellas
		camasDisponibles = _camas
		spaDisponible = _spaDisponible
	}
	
}

object vehiculo {
	var property asientosDisponibles = 10 // lugares disponibles del VEHICULO
	var aireAcondicionado = false // si el VEHICULO tiene  aire acond.
	var vtv = true // si el VEHICULO tiene la vtv
	
	method sePuedeReservar(_paquete) {
		// Un traslado se puede reservar si el vehiculo cuenta con 
		// lugares disponibles y tiene la verificacion tecnica al dia.
		// Si el paquete es premium, tambien tiene que cumplir que  
		// tenga aire Acondicionado
		return self.asientosDisponibles() >= _paquete.cantidadPersonas() and self.tieneVTV() and (not _paquete.premium() or self.tieneAireAcondicionado())
	}
	
	method tieneAireAcondicionado() {
		return aireAcondicionado
	}

	method tieneVTV() {
		return vtv
	}
	
	method reservar(_paquete) {
		self.asientosDisponibles(self.asientosDisponibles() - _paquete.cantidadPersonas())
	}

	method configurar(_tieneAire, _tieneVtv, _asientosDisponibles) {
		aireAcondicionado = _tieneAire
		vtv = _tieneVtv
		asientosDisponibles = _asientosDisponibles
	}
	
}

object servicio {

	var property alojamiento = hotel
	var property traslado = vehiculo

	var esCombinado = false
	
	method sePuedeReservar(_paquete) {
		
		if (self.esCombinado()) {
			// Si es combinado tiene que cumplir el requierimiento del hotel y del vehiculo
			return alojamiento.sePuedeReservar(_paquete) and 
						traslado.sePuedeReservar(_paquete)
		}
		return false //??
	}
	
	method reservar(_paquete) {
						
		if(self.esCombinado()) {
			traslado.reservar(_paquete)
			alojamiento.reservar(_paquete)
		}
	}


	method configurarComoCombinado(_estrellas, _camas, _spaDisponible, _tieneAire, _tieneVtv, _asientosDisponibles) {
		esCombinado = true
		
		alojamiento.configurar(_estrellas, _camas, _spaDisponible)
        traslado.configurar(_tieneAire, _tieneVtv, _asientosDisponibles)
	}

	
	method esCombinado() {
		return esCombinado
	}
	
	method camasDisponibles() {
		return alojamiento.camasDisponibles()
	}
	
	method spaDisponible() {
		return alojamiento.spaDisponible()
	}
	
	method asientosDisponibles() {
		return traslado.asientosDisponibles()
	}

}

