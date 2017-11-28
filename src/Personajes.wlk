import Materiales.*
import Experimentos.*
import Estrategias.*
import Humor.*

/************************************************************************************************/
object rick {
	var companiero
	var mochila = #{}
	var experimentos = #{construirBateria, construirCircuito, shockElectrico}
	var estrategia = alAzar
	
	method companiero() = companiero
	method asignarCompanero(unCompanero) { companiero = unCompanero }
	method mochila() = mochila
	method estrategia() = estrategia
	method estrategia(_unaEstrategia){ estrategia = _unaEstrategia }
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	method experimentosQuePuedeRealizar() {
		return experimentos.filter({e => e.puedeRealizarse(self)})
	}
	
	method realizar(unExperimento) {
		unExperimento.realizar(self)
	}
	
}

/************************************************************************************************/
/************************************************************************************************/
class Companiero {
	var energia = 0
	var mochila = #{}
	
	method energia() = energia
	method mochila() = mochila
	method reducirEnergia(_energia){ energia = (energia - _energia).max(0) }
  	method recuperarEnergia(_energia){ energia += _energia }
  	
  	method capacidadMochila()
	method puedeRecolectar(_unMaterial) = (mochila.size() < self.capacidadMochila()) 
	
	method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
			_unMaterial.consecuenciaRecoleccion(self)
		}
		else {
			self.error("No se pudo recolectar")
		}
	}
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(mochila)
		mochila.clear()
	}
}
/************************************************************************************************/
object morty inherits Companiero {
	override method capacidadMochila() = 3
	
	override method puedeRecolectar(_unMaterial) = super(_unMaterial) && (energia >= _unMaterial.energiaNecesaria())
}
/************************************************************************************************/
object summer inherits Companiero {
	const costoEnergiaPorEntrega = 10
	const porcentajeConsumo = 0.8
	
	override method capacidadMochila() = 2
	
	override method puedeRecolectar(_unMaterial) = super(_unMaterial) && (energia >= (_unMaterial.energiaNecesaria() * porcentajeConsumo))   // Usa un 20% menos de Energía que Morty, y solo carga de a 2 materiales.
	
	override method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
			_unMaterial.consecuenciaRecoleccion(self, porcentajeConsumo)
		}
		else {
			self.error("No se pudo recolectar")
		}
	}
	
	override method darObjetosA(_unCompanero){
		super(_unCompanero)
		self.reducirEnergia(costoEnergiaPorEntrega)
	}
}

/**************************************************************************************************/

object jerry inherits Companiero {
	var humor = buenHumor
	var sobreExitado = false
	
	override method capacidadMochila() {
		if (sobreExitado) {
			return humor.capacidadMochila() * 2
		}
		else {
			return humor.capacidadMochila()
		}
	}
	
	override method puedeRecolectar(_unMaterial) = super(_unMaterial) && (energia >= _unMaterial.energiaNecesaria())
	
	override method recolectar(_unMaterial){
		super(_unMaterial)
		if (sobreExitado) { self.soltarTodoRandom() }
		if (_unMaterial.estaVivo()) { humor = buenHumor }
		if (_unMaterial.esRadioactivo()) { sobreExitado = true }
	}
	method soltarTodoRandom(){
		if ([true,false,false,false].anyOne()){
			mochila.clear()
			sobreExitado = false
		}
	}
	
	override method darObjetosA(_unCompanero){
		super(_unCompanero)
		humor = malHumor
		sobreExitado = false
	}
}


