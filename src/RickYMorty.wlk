/* 
 * Morty
 * 	energia
 * 	materiales //hasta 3
 * 	
 * 	puedeRecolectar(unMaterial)
 * 	recolectar(unMaterial)//la recolecta (si puede) y se la guarda en su mochila.
 * 		//necetita tanta energia como grMetal del elemento
 * 		//Al recolectar materiales radiactivos, la energía de Morty disminuye en la cantidad requerida luego de la acción
 * 	darObjetosA(unCompanero)//saca todas las cosas de su mochila y se las pasa a un compañero
 * 	reducir(_energia)
 * 	recuperar(_energia)
 * ****************************
 * 
 * Materiales
 * 	grMetal
 * 	conduceE
 * 	esRadioactivo
 * 	generaE
 * 	
 * 	energiaNecesaria() = self.grMetal() 
 * 	descontarEnergia(companiero) { companiero.energia(companiero.energia() - self.energiaNecesaria()) }
 * 
 * 
 * Lata
 * 	grMetal //variable
 * 	conduceE = 0.1 * grMetal
 * 	esRadioactivo=false
 * 	generaE = 0
 * 
 * Cable
 * 	grMetal = ((longitud / 1000) * seccion)
 * 	conduceE = seccion * 3
 * 	esRadioactivo = false
 * 	generaE = 0
 * 	longitud //variable
 * 	seccion //variable
 * 
 * Fleeb
 * 	grMetal = materiales.sum({m => m.grMetal()})
 * 	conduceE = materiales.max({m => m.conduceE()}).conduceE()
 * 	esRadioactivo = anios>15
 * 	generaE = materiales.min({m => m.generaE()}).generaE()
 * 	materiales = #{}
 * 	anios //variable
 * 
 * 	override energiaNecesaria() = super() * 2
 * 	override descontarEnergia(companiero) {
 * 		if (!self.esRadioactivo()) {
 * 			companiero.energia(companiero.energia() + 10)
 * 		} 
 * 	}
 * 
 * MateriaOscura
 * 	grMetal = materiaBase.grMetal()
 * 	conduceE = materiaBase.conduceE()
 * 	esRadioactivo = false
 * 	generaE = materiaBase.generaE() * 2
 * 	materiaBase //variable
 * 
 * ************************
 * Rick
 * 	companero
 * 	mochila
 * 
 * 
 * 
 * cosa nueva
 */

//==================================================
//-------------------------------------------- MORTY
//==================================================

object morty{
	
	var energia
	var mochila = #{}//maximo 3 materiales a la vez.
	
	method puedeRecolectar(_unMaterial){
		return energia >= _unMaterial.energiaNecesaria() and mochila.size() < 3
	}
	
	method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
		}
		else
			self.error("no se pudo recolectar")
		
	}
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(self.mochila())
		mochila.clear()
	}
	
	method mochila() = mochila // Este método devuelve la lista con todos los materiales de la mochila.
	
	method recibir(unosMateriales){
		mochila.union(unosMateriales)
	}
	
	method reducir(_energia){
		energia -= _energia
	}
  	
  	method recuperar(_energia){
  		energia += _energia
  	}
	
}


//=============================================================
//-------- Material -------------------------------------------
//=============================================================
class Material {
	var grMetal
	var conduceE
	var esRadioactivo
	var generaE
	
	/*constructor(_grMetal,_conduceE,_esRadioactivo,_generaE) {
		grMetal = _grMetal
		conduceE = _conduceE
		esRadioactivo = _esRadioactivo
		generaE = _generaE
	}*/
	
	method grMetal() = grMetal
	method conduceE() = conduceE
	method esRadioactivo() = esRadioactivo
	method generaE() = generaE
	
	method energiaNecesaria() = self.grMetal() 
	method descontarEnergia(companiero) { companiero.energia(companiero.energia() - self.energiaNecesaria()) }
}
/************************************************************/
class Lata inherits Material {
	
	constructor(_grMetal) {
		grMetal = _grMetal
		esRadioactivo = false
		generaE = 0
	}
	
	override method conduceE() = 0.1 * grMetal
}
/************************************************************/
class Cable inherits Material {
	var longitud //variable
	var seccion //variable
	
	constructor(_longitud, _seccion) {
		longitud = _longitud
		seccion = _seccion
		esRadioactivo = false
		generaE = 0
	}
	
	override method grMetal() = ((longitud / 1000) * seccion)
	override method conduceE() = seccion * 3
}
/************************************************************/
class Fleeb inherits Material {
	var materiales = #{}
	var anios
	
	constructor(_materiales, _anios){
		materiales = _materiales
		anios = _anios
	}
	
	method agregarmaterial(_material){ materiales.add(_material) }
	method anios(_anios) { anios = _anios }
	
	override method grMetal() = materiales.sum({m => m.grMetal()})
	override method conduceE() = materiales.max({m => m.conduceE()}).conduceE()
	override method esRadioactivo() = anios > 15
	override method generaE() = materiales.min({m => m.generaE()}).generaE()
	
	override method energiaNecesaria() = super() * 2
	override method descontarEnergia(companiero) {
		if (!self.esRadioactivo()) {
			companiero.energia(companiero.energia() + 10)
		} 
	}
}
/************************************************************/
class MateriaOscura inherits Material {
	var materiaBase //variable
	
	constructor(_materiaBase) {
		materiaBase = _materiaBase
		esRadioactivo = false
	}
	
	override method grMetal() = materiaBase.grMetal()
	override method conduceE() = materiaBase.conduceE()
	override method generaE() = materiaBase.generaE() * 2
}

//=============================================================
//--------------------- PARTE 2 -------------------------------
//=============================================================

object rick {
	
	var mochila = #{}
	var companero = morty // el enunciado aclara que en este caso el compañero es Morty, pero en otros universos puede cambiar.
	
	method asignarCompanero(unCompanero){
		companero = unCompanero
	}
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
		_unCompanero.recibir(self.mochila())
		mochila.clear()
	}
	
	method mochila() = mochila // Este método devuelve la lista con todos los materiales de la mochila.
	
	method recibir(unosMateriales){
		mochila.union(unosMateriales)
	}
	
	method experimentosQuePuedeRealizar(){}
	
	method realizar(unExperimento){}
	
}


//Materiales Generables
class Bateria inherits Material {
	constructor(materiales) {
		grMetal = materiales.sum({m => m.grMetal()})
		conduceE = 0
		esRadioactivo = true
		generaE = grMetal * 2
	}
}
class Circuito inherits Material {
	constructor(materiales) {
		grMetal = materiales.sum({m => m.grMetal()})
		conduceE = materiales.sum({m => m.conduceE()}) * 3
		esRadioactivo = materiales.any({m => m.esRadioactivo()})
		generaE = 0
	}
}

//Experimentos
object construirBateria {
	method buscarMateriales(mochila) {
		var materialesMetaleros = mochila.filter({m => m.grMetal() > 200})
		var materialesRadiactivos = mochila.filter({m => m.esRadioactivo()})
		var materialesSeleccionados = #{}
		
		//habria que validar que los materiales no se repitan ni quedarse corto innecesariamente
		return materialesSeleccionados
	}
	method puedeRealizarse(mochila) = self.buscarMateriales(mochila).size() == 2
	
	method realizar(mochila, companiero) {
		if (self.puedeRealizarse(mochila)) {
			var materiales = self.buscarMateriales(mochila)
			mochila.removeAll(materiales)
			mochila.add(new Bateria(materiales))
			companiero.energia((companiero.energia() - 5).max(0))
		}
		else {
			self.error("No se puede realizar el experimento.")
		}
	}
}
object construirCircuito {
	
	method buscarMateriales(mochila) = mochila.filter({m => m.conduceE() >= 5})
	
	method puedeRealizarse(mochila) = self.buscarMateriales(mochila).size() > 0
	
	method realizar(mochila, companiero) {
		if (self.puedeRealizarse(mochila)) {
			var materiales = self.buscarMateriales(mochila)
			mochila.removeAll(materiales)
			mochila.add(new Circuito(materiales))
		}
		else {
			self.error("No se puede realizar el experimento.")
		}
	}
}
object shockElectrico {
	
	method buscarMateriales(mochila) {
		var generador = mochila.filter({m => m.generaE() > 0})
		var conductor = mochila.filter({m => m.conduceE() > 0})
		// falta seguir
	}
	
	method puedeRealizarse(mochila) = self.buscarMateriales(mochila).size() == 2
	
	method realizar(mochila, companiero) {
		companiero.energia(companiero.energia() + (generador.generaE() * conductor.conduceE()))
	}
}
	
	
	
	
	
	
