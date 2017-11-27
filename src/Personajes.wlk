import Materiales.*
import Experimentos.*
import Estrategias.*
import Humor.*


/************************************************************************************************/

class Personaje {
	var energia = 0
	var companiero
	var mochila = #{}
	
	method asignarCompanero(unCompanero) { companiero = unCompanero }
	
	method energia() = energia
	method companiero() = companiero
	method mochila() = mochila
	
	method reducirEnergia(_energia){ energia = (energia - _energia).max(0) }
  	method recuperarEnergia(_energia){ energia += _energia }
  	
	method puedeRecolectar(_unMaterial)
	
	method recolectar(_unMaterial)
	
	method puedeRecibir(unosMateriales)
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(mochila)
		mochila.clear()
	}
	
	method recibir(unosMateriales){
		if (self.puedeRecibir(unosMateriales)){
			mochila.addAll(unosMateriales)
		}
		else{
			self.error("La mochila del Compañero no tiene suficiente lugar")
		}
	}
	
	method descartarMaterialAlAzar() {
  		if (!mochila.isEmpty()){
  			mochila.remove(mochila.anyOne())
  		}
  	}
}
/************************************************************************************************/

object morty inherits Personaje {
	const capacidadMochila = 3
	
	override method puedeRecolectar(_unMaterial){
		return energia >= _unMaterial.energiaNecesaria() and mochila.size() < capacidadMochila  //maximo 3 materiales a la vez.
	}
	
	override method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
			_unMaterial.descontarEnergia(self)
		}
		else {
			self.error("No se pudo recolectar")
		}
	}	
	
	override method puedeRecibir(unosMateriales){ return (mochila.size() + unosMateriales.size() < 2)}
}
/************************************************************************************************/
object rick inherits Personaje {
	
	var experimentos = #{construirBateria, construirCircuito, shockElectrico}
	var estrategia = alAzar
	  
	method estrategia() = estrategia
	method estrategia(_unaEstrategia){ estrategia = _unaEstrategia }
	override method puedeRecolectar(_unMaterial){} // Eventualmente Rick no recolecta, pero en un futuro podría, por lo que queda el metodo "Abstracto"
	override method recolectar(_unMaterial){}  // Idem arriba 
	override method puedeRecibir(unosMateriales) = true // Rick no tiene limitación de cantidad en su mochila
	
	method experimentosQuePuedeRealizar() {
		return experimentos.filter({e => e.puedeRealizarse(self)})
	}
	
	method realizar(unExperimento) {
		unExperimento.realizar(self)
	}
	
}
/************************************************************************************************/

object summer inherits Personaje {
	const capacidadMochila = 2
	const costoEnergiaPorEntrega = 10
	
	override method puedeRecolectar(_unMaterial){
		return energia >= (_unMaterial.energiaNecesaria()*0.8) and mochila.size() < capacidadMochila   // Usa un 20% menos de Energía que Morty, y solo carga de a 2 materiales.
	}
	
	override method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
			_unMaterial.descontarEnergia(self)
		}
		else {
			self.error("No se pudo recolectar")
		}
	}	
	
	override method puedeRecibir(unosMateriales){ return (mochila.size() + unosMateriales.size() < 2)}
	
	override method darObjetosA(_unCompanero){
		super(_unCompanero)
		_unCompanero.reducirEnergia(costoEnergiaPorEntrega)
	}
}

/**************************************************************************************************/

object jerry inherits Personaje {
	var humor = buenHumor
	
	override method puedeRecolectar(_unMaterial) = humor.puedeRecolectar(self)
	
	override method recolectar(_unMaterial){
		humor.recolectar(self, _unMaterial)
		if (_unMaterial.estaVivo()) { 
			humor = buenHumor
		}
		else if (_unMaterial.esRadioactivo()) {
			humor = sobreExcitado
		}
	}
	
	override method puedeRecibir(unosMateriales) = humor.puedeRecibir(self,unosMateriales)
	
	override method darObjetosA(_unCompanero){
		super(_unCompanero)
		humor = malHumor
	}
}


