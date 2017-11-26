//=============================================================
//-------- Material -------------------------------------------
//=============================================================
class Material {
	/*var grMetal
	var conduceE
	var esRadioactivo
	var generaE
	
	constructor(_grMetal,_conduceE,_esRadioactivo,_generaE) {
		grMetal = _grMetal
		conduceE = _conduceE
		esRadioactivo = _esRadioactivo
		generaE = _generaE
	}*/
	
	method grMetal()
	method conduceE()
	method esRadioactivo()
	method generaE()
	method estaVivo()
	
	method energiaNecesaria() = self.grMetal() 
	method descontarEnergia(companiero) { companiero.reducirEnergia(self.energiaNecesaria()) }
}
/************************************************************/
class Lata inherits Material {
	var grMetal
	
	constructor(_grMetal) {
		grMetal = _grMetal
	}
	
	override method grMetal() = grMetal
	override method conduceE() = 0.1 * grMetal
	override method esRadioactivo() = false
	override method generaE() = 0
	override method estaVivo() = false
}
/************************************************************/
class Cable inherits Material {
	var longitud
	var seccion
	
	constructor(_longitud, _seccion) {
		longitud = _longitud
		seccion = _seccion
	}
	
	override method grMetal() = (longitud / 1000) * seccion
	override method conduceE() = seccion * 3
	override method esRadioactivo() = false
	override method generaE() = 0
	override method estaVivo() = false
}
/************************************************************/
class Fleeb inherits Material {
	var materiales = #{}
	var anios
	var serVivo = true
	
	constructor(_materiales, _anios){
		materiales.add(_materiales)
		anios = _anios
	}
	
	method agregarmaterial(_material){ materiales.add(_material) }
	method anios(_anios) { anios = _anios }
	
	override method grMetal() = materiales.sum({m => m.grMetal()})
	override method conduceE() = materiales.max({m => m.conduceE()}).conduceE()
	override method esRadioactivo() = anios > 15
	override method generaE() = materiales.min({m => m.generaE()}).generaE()
	override method estaVivo() = true
	method serVivo() = self.estaVivo() //agregado para pregunta en buscarMaterialEcologico--Experimento
	
	override method energiaNecesaria() = self.grMetal() * 2
	override method descontarEnergia(companiero) {
		if (!self.esRadioactivo()) {
			companiero.recuperarEnergia(10)
		} 
	}
}
/************************************************************/
class MateriaOscura inherits Material {
	var materiaBase //variable
	
	constructor(_materiaBase) {
		materiaBase = _materiaBase
	}
	
	method materiaBase(_materiaBase){
		materiaBase = _materiaBase
	}
	
	override method grMetal() = materiaBase.grMetal()
	override method conduceE() = materiaBase.conduceE()
	override method esRadioactivo() = false
	override method generaE() = materiaBase.generaE() * 2
	override method estaVivo() = false
	
	override method energiaNecesaria() = self.grMetal() 
	override method descontarEnergia(companiero) { companiero.reducirEnergia(self.energiaNecesaria()) }
}
/************************************************************/
class ParasitoAlienigena inherits Material {
	var acciones
	
	constructor(_acciones) {
		acciones = _acciones
	}
	
	override method grMetal() = 10
	override method conduceE() = 0
	override method esRadioactivo() = false
	override method generaE() = 5
	override method estaVivo() = true
	
	override method descontarEnergia(companiero) {
		//super(companiero)
		acciones.forEach({a => a.apply(companiero)})
	}
}


/************************************************************/
//Materiales Generables
/************************************************************/
class Bateria inherits Material {
	var materiales
	
	constructor(_materiales) {
		materiales = _materiales
	}
	
	override method grMetal() = materiales.sum({m => m.grMetal()})
	override method conduceE() = 0
	override method esRadioactivo() = true
	override method generaE() = materiales.sum({m => m.grMetal()}) * 2
	override method estaVivo() = false
}
/************************************************************/
class Circuito inherits Material {
	var materiales
	
	constructor(_materiales) {
		materiales = _materiales
	}
	
	override method grMetal() = materiales.sum({m => m.grMetal()})
	override method conduceE() = materiales.sum({m => m.conduceE()}) * 3
	override method esRadioactivo() = materiales.any({m => m.esRadioactivo()})
	override method generaE() = 0
	override method estaVivo() = false
}