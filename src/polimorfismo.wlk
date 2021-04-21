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

object servicio {

	var property alojamiento = hotel

	var property asientosDisponibles = 10 // lugares disponibles del VEHICULO
	var aireAcondicionado = false // si el VEHICULO tiene  aire acond.
	var vtv = true // si el VEHICULO tiene la vtv

	var esVehiculoParaTraslado = false
	var esCombinado = false
	
	method sePuedeReservar(_paquete) {
		
		if (self.esVehiculoParaTralado()) {
			// Un traslado se puede reservar si el vehiculo cuenta con 
			// lugares disponibles y tiene la verificacion tecnica al dia.
			// Si el paquete es premium, tambien tiene que cumplir que  
			// tenga aire Acondicionado
			return self.asientosDisponibles() >= _paquete.cantidadPersonas() and self.tieneVTV() and (not _paquete.premium() or self.tieneAireAcondicionado())
		}
		if (self.esCombinado()) {
			// Si es combinado tiene que cumplir el requierimiento del hotel y del vehiculo
			return alojamiento.sePuedeReservar(_paquete) and 
						self.asientosDisponibles() >= _paquete.cantidadPersonas() and self.tieneVTV() 
						and (not _paquete.premium() or self.tieneAireAcondicionado())
		}
		return false //??
	}
	
	method reservar(_paquete) {
		if(self.esVehiculoParaTralado()){
			self.asientosDisponibles(self.asientosDisponibles() - _paquete.cantidadPersonas())
		}
						
		if(self.esCombinado()) {
			self.asientosDisponibles(self.asientosDisponibles() - _paquete.cantidadPersonas())
			alojamiento.reservar(_paquete)
		}
	}

	method configurarComoVehiculo(_tieneAire, _tieneVtv, _asientosDisponibles) {
		esCombinado = false
		esVehiculoParaTraslado = true
		aireAcondicionado = _tieneAire
		vtv = _tieneVtv
		asientosDisponibles = _asientosDisponibles
	}

	method configurarComoCombinado(_estrellas, _camas, _spaDisponible, _tieneAire, _tieneVtv, _asientosDisponibles) {
		esCombinado = true
		esVehiculoParaTraslado = false
		
		alojamiento.configurar(_estrellas, _camas, _spaDisponible)

		aireAcondicionado = _tieneAire
		vtv = _tieneVtv
		asientosDisponibles = _asientosDisponibles
	}

	
	method esCombinado() {
		return esCombinado
	}

	method esVehiculoParaTralado() {
		return esVehiculoParaTraslado
	}

	method tieneAireAcondicionado() {
		return aireAcondicionado
	}

	method tieneVTV() {
		return vtv
	}
	
	method camasDisponibles() {
		return alojamiento.camasDisponibles()
	}
	
	method spaDisponible() {
		return alojamiento.spaDisponible()
	}

}

