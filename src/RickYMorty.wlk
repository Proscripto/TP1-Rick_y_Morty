//==================================================
//-------------------------------------------- MORTY
//==================================================

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
	method descontarEnergia(companiero) { companiero.reducirEnergia(self.energiaNecesaria()) }
}
/************************************************************/
class Lata inherits Material {
	constructor(_grMetal) {
		grMetal = _grMetal
		conduceE = 0.1 * _grMetal
		esRadioactivo = false
		generaE = 0
	}
}
/************************************************************/
class Cable inherits Material {
	constructor(longitud, seccion) {
		grMetal = ((longitud / 1000) * seccion)
		conduceE = seccion * 3
		esRadioactivo = false
		generaE = 0
	}
}
/************************************************************/
class Fleeb inherits Material {
	var materiales = #{}
	var anios
	
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
	
	override method energiaNecesaria() = super() * 2
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
		esRadioactivo = false
	}
	
	method materiaBase(_materiaBase){
		materiaBase = _materiaBase
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
	var companiero = morty // el enunciado aclara que en este caso el compañero es Morty, pero en otros universos puede cambiar.
	var experimentos = #{construirBateria, construirCircuito, shockElectrico}
	
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
	
	method recibir(unosMateriales){
		mochila.addAll(unosMateriales)
	}
	
	method experimentosQuePuedeRealizar() {
		return experimentos.filter({e => e.puedeRealizarse(mochila)})
	}
	
	method realizar(unExperimento) {
		unExperimento.realizar(mochila, companiero)
	}
	
}


/************************************************************/
//Materiales Generables
/************************************************************/
class Bateria inherits Material {
	constructor(materiales) {
		grMetal = materiales.sum({m => m.grMetal()})
		conduceE = 0
		esRadioactivo = true
		generaE = grMetal * 2
	}
}
/************************************************************/
class Circuito inherits Material {
	constructor(materiales) {
		grMetal = materiales.sum({m => m.grMetal()})
		conduceE = materiales.sum({m => m.conduceE()}) * 3
		esRadioactivo = materiales.any({m => m.esRadioactivo()})
		generaE = 0
	}
}
/************************************************************/
//Experimentos
/************************************************************/
class Experimento {
	method buscar2Materiales(mochila, cond1, cond2) {
		//armo un conjunto con todos los materiales con mas de 200gr de metal y otro con los radiactivos
		var materialesCond1 = mochila.filter(cond1) 
		var materialesCond2 = mochila.filter(cond2)
		var materialesSeleccionados = [] //lista de materiales que se retornaran
		
		//Reviso que haya por lo menos un material en cada conjunto
		if (materialesCond1.size() > 0 && materialesCond2.size() > 0) { 
			//Primero busco un material que solo cumpla la condicion >200gr metal para evitar que mas adelante me pueda limitar en la seleccion del segundo material
			//Si no existe busco cualquiera de ese conjunto
			if (materialesCond1.difference(materialesCond2).size() > 0) {
				materialesSeleccionados.add(materialesCond1.difference(materialesCond2).anyOne())
			}
			else {
				materialesSeleccionados.add(materialesCond1.anyOne())
			}
			//a esta altura ya tendria el primer elemento de la mochila seleccionado ya que por lo menos hay uno >200gr metal
			//ahora busco algun otro que cumpla la segunda condicion
			if (materialesCond2.difference(materialesSeleccionados).size() > 0) {
				materialesSeleccionados.add(materialesCond2.difference(materialesSeleccionados).anyOne())
			}
			//si no encuentra un elemento limpio la lista ya que se necesitan 2 para realizar el experimento
			if (materialesSeleccionados.size()!=2) {
				materialesSeleccionados.clear()
			}
		}
		return materialesSeleccionados
	}
	
	method realizar(mochila,companiero)
	method puedeRealizarse(mochila)
}
/************************************************************/
object construirBateria inherits Experimento {
	const condMat1 = {m => m.grMetal() > 200}
	const condMat2 = {m => m.esRadioactivo()}
	
	 override method puedeRealizarse(mochila) {
		return self.buscar2Materiales(mochila, condMat1, condMat2).size() == 2
	}
	
	override method realizar(mochila, companiero) {
		if (self.puedeRealizarse(mochila)) {
			var materiales = self.buscar2Materiales(mochila, condMat1, condMat2)
			mochila.removeAll(materiales)
			mochila.add(new Bateria(materiales))
			companiero.reducirEnergia(5)
		}
		else {
			self.error("No se puede realizar el experimento.")
		}
	}
}
/************************************************************/
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
/************************************************************/
object shockElectrico inherits Experimento {
	const condMat1 = {m => m.generaE() > 0}
	const condMat2 = {m => m.conduceE() > 0}
	
	override method puedeRealizarse(mochila) {
		return self.buscar2Materiales(mochila, condMat1, condMat2).size() == 2
	}
	
	override method realizar(mochila, companiero) {
		if (self.puedeRealizarse(mochila)) {
			var materiales = self.buscar2Materiales(mochila, condMat1, condMat2)
			mochila.removeAll(materiales)
			companiero.recuperarEnergia(materiales.first().generaE() * materiales.last().conduceE())
		}
		else {
			self.error("No se puede realizar el experimento.")
		}
	}
}
	
	
	
	
	
	
