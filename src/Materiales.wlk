//=============================================================
//-------- Material -------------------------------------------
//=============================================================
class Material {
	var grMetal
	var conduceE
	var esRadioactivo
	var generaE
	
	constructor(_grMetal,_conduceE,_esRadioactivo,_generaE) {
		grMetal = _grMetal
		conduceE = _conduceE
		esRadioactivo = _esRadioactivo
		generaE = _generaE
	}
	
	method grMetal() = grMetal
	method conduceE() = conduceE
	method esRadioactivo() = esRadioactivo
	method generaE() = generaE
	
	method energiaNecesaria() = self.grMetal() 
	method descontarEnergia(companiero) { companiero.reducirEnergia(self.energiaNecesaria()) }
}
/************************************************************/
class Lata inherits Material {
	constructor(_grMetal) = super(_grMetal, 0.1 * _grMetal, false, 0)
}
/************************************************************/
class Cable inherits Material {
	constructor(longitud, seccion) = super(((longitud / 1000) * seccion), seccion * 3, false, 0)
}
/************************************************************/
class Fleeb /*inherits Material*/ {
	var materiales = #{}
	var anios
	
	constructor(_materiales, _anios){
		materiales.add(_materiales)
		anios = _anios
	}
	
	method agregarmaterial(_material){ materiales.add(_material) }
	method anios(_anios) { anios = _anios }
	
	method grMetal() = materiales.sum({m => m.grMetal()})
	method conduceE() = materiales.max({m => m.conduceE()}).conduceE()
	method esRadioactivo() = anios > 15
	method generaE() = materiales.min({m => m.generaE()}).generaE()
	
	method energiaNecesaria() = self.grMetal() * 2
	method descontarEnergia(companiero) {
		if (!self.esRadioactivo()) {
			companiero.recuperarEnergia(10)
		} 
	}
}
/************************************************************/
class MateriaOscura {
	var materiaBase //variable
	
	constructor(_materiaBase) {
		materiaBase = _materiaBase
	}
	
	method materiaBase(_materiaBase){
		materiaBase = _materiaBase
	}
	
	method grMetal() = materiaBase.grMetal()
	method conduceE() = materiaBase.conduceE()
	method esRadioactivo() = false
	method generaE() = materiaBase.generaE() * 2
	
	method energiaNecesaria() = self.grMetal() 
	method descontarEnergia(companiero) { companiero.reducirEnergia(self.energiaNecesaria()) }
}


/************************************************************/
//Materiales Generables
/************************************************************/
class Bateria inherits Material {
	constructor(materiales) = super(
		materiales.sum({m => m.grMetal()})
		,0
		,true
		,materiales.sum({m => m.grMetal()}) * 2
	)
}
/************************************************************/
class Circuito inherits Material {
	constructor(materiales) = super(
		materiales.sum({m => m.grMetal()})
		,materiales.sum({m => m.conduceE()}) * 3
		,materiales.any({m => m.esRadioactivo()})
		,0
	)
}