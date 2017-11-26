import Materiales.*
import Experimentos.*
import Estrategias.*

/************************************************************************************************/
object morty{
	
	var energia = 0
	var mochila = #{}//maximo 3 materiales a la vez.
	
	method puedeRecolectar(_unMaterial){
		return energia >= _unMaterial.energiaNecesaria() and mochila.size() < 3
	}
	
	method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
			_unMaterial.descontarEnergia(self)
		}
		else {
			self.error("No se pudo recolectar")
		}
	}
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(mochila)
		mochila.clear()
	}
	
	method energia() = energia
	method mochila() = mochila // Este método devuelve la lista con todos los materiales de la mochila.
	
	/*method recibir(unosMateriales){
		mochila.union(unosMateriales)
	} morty no necesita este metodo*/
	
	method reducirEnergia(_energia){
		energia = (energia - _energia).max(0)
	}
  	
  	method recuperarEnergia(_energia){
  		energia += _energia
  	}
	
}
/************************************************************************************************/
object rick {
	var mochila = #{}
	var companiero = morty // el enunciado aclara que en este caso el compañero es Morty, pero en otros universos puede cambiar.
	var experimentos = #{construirBateria, construirCircuito, shockElectrico}
	var estrategia = alAzar
	
	method asignarCompanero(unCompanero){
		companiero = unCompanero
	}
	
	//Comente este metodo porque no lo pedia y haria quilombo si tubiera mas materiales de los que puede recibir el companiero
	/*method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(self.mochila())
		mochila.clear()
	}*/
	
	method mochila() = mochila // Este método devuelve la lista con todos los materiales de la mochila.
	method companiero() = companiero
	method estrategia() = estrategia
	
	method estrategia(_unaEstrategia){
		estrategia = _unaEstrategia
	}
	
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