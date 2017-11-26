import Materiales.*
import Experimentos.*
import Estrategias.*


/************************************************************************************************/

class Personaje {
	var energia = 0
	var companiero
	var mochila = #{}
	
	method asignarCompanero(unCompanero){
		companiero = unCompanero
	}
	
	method puedeRecolectar(_unMaterial)
	
	method recolectar(_unMaterial)
	
	method puedeRecibir(unosMateriales)
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(mochila)
		mochila.clear()
	}
	
	method energia() = energia
	
	method mochila() = mochila // Este método devuelve la lista con todos los materiales de la mochila.
	
	method companiero() = companiero
	
	method recibir(unosMateriales){
		if (self.puedeRecibir(unosMateriales)){
			mochila.union(unosMateriales)
		}
		else{
			self.error("La mochila del Compañero no tiene suficiente lugar")
		}
	}
	
	method reducirEnergia(_energia){
		energia = (energia - _energia).max(0)
	}
  	
  	method recuperarEnergia(_energia){
  		energia += _energia
  	}
  	
  	method descartarMaterialAlAzar() {
  		if (!mochila.isEmpty()){
  			mochila.remove(mochila.anyOne())
  		}
  	}
}
/************************************************************************************************/

object morty inherits Personaje {

	
	
	override method puedeRecolectar(_unMaterial){
		return energia >= _unMaterial.energiaNecesaria() and mochila.size() < 3   //maximo 3 materiales a la vez.
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
	

/************************************************************************************************/
object rick inherits Personaje {
	
	var experimentos = #{construirBateria, construirCircuito, shockElectrico}
	var estrategia = alAzar
  
  method estrategia() = estrategia
	
	method estrategia(_unaEstrategia){ estrategia = _unaEstrategia }
  
	override method puedeRecolectar(_unMaterial){} // Eventualmente Rick no recolecta, pero en un futuro podría, por lo que queda el metodo "Abstracto"
	
	override method recolectar(_unMaterial){}  // Idem arriba 
	
	override method puedeRecibir(unosMateriales){return true} // Rick no tiene limitación de cantidad en su mochila
	
	method experimentosQuePuedeRealizar() {
		return experimentos.filter({e => e.puedeRealizarse(self)})
	}
	
	method realizar(unExperimento) {
		
		unExperimento.realizar(self)
	}
	
}
/************************************************************************************************/

object summer inherits Personaje {
	
	const energiaQueDescuenta = 10
	
	override method puedeRecolectar(_unMaterial){
		return energia >= (_unMaterial.energiaNecesaria()*0.8) and mochila.size() < 2   // Usa un 20% menos de Energía que Morty, y solo carga de a 2 materiales.
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
		_unCompanero.reducirEnergia(energiaQueDescuenta)
	}
}

/**************************************************************************************************/

object jerry inherits Personaje {
	
	var humor = buenHumor
	
	method humor(){   

		if (rick.companiero() == self){ 
			 humor = malHumor
		}
		if (mochila.any({elem => elem.estaVivo()})){ 
			humor = buenHumor
		}
		if (mochila.any({elem => elem.esRadioactivo()})){
			humor = sobreexcitado
		}
	} 
	
	override method puedeRecolectar(_unMaterial){
	
		return (humor.puedeRecolectar())
	}
	
	override method recolectar(_unMaterial){

		humor.recolectar(_unMaterial)
	}	
	
	override method puedeRecibir(unosMateriales){ return ((mochila.size() + unosMateriales.size()) < 3)}
}

/**********Clases de Humor para Jerry***********/

class Humor {
	
	method puedeRecolectar(_unMaterial)
	
	method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			jerry.recibir(_unMaterial)
			_unMaterial.descontarEnergia(self)
		}
		else {
			self.error("No se pudo recolectar")
		}
	}
}

object buenHumor inherits Humor {
	
	override method puedeRecolectar(_unMaterial){
		return ((jerry.energia() >= _unMaterial.energiaNecesaria()) and (jerry.mochila().size() < 3))   //maximo 3 materiales a la vez. Idem a Morty
	}	
}

object malHumor inherits Humor {
	
	override method puedeRecolectar(_unMaterial){
		return ((jerry.energia() >= _unMaterial.energiaNecesaria()) and (jerry.mochila().size() < 1))
	}	
}

object sobreexcitado inherits Humor {
	
	override method puedeRecolectar(_unMaterial){
		return ((jerry.energia() >= _unMaterial.energiaNecesaria()) and (jerry.mochila().size() < 6))
	}
	
	override method recolectar(_unMaterial){
		super(_unMaterial)
		self.soltarTodo()
	}
	
	method soltarTodo(){    //Este método tira todo lo de la mochila, pues si se pasa la mochila a si mismo luego hace un clear(mochila) y pierde todo
		if (self.randomBoolean()){
			jerry.darObjetosA(jerry)
		}
	}
	
	method randomBoolean(){
		return ([true,false,false,false].anyOne())			
	}
}
