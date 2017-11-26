import Materiales.*

/************************************************************/
class Experimento {
	method buscar2Materiales(mochila, cond1, cond2) {
		//armo un conjunto con todos los materiales con mas de 200gr de metal y otro con los radiactivos
		var materialesCond1 = mochila.filter(cond1) 
		var materialesCond2 = mochila.filter(cond2)
		var materialesSeleccionados = [] //lista de materiales que se retornaran
		
		//Reviso que haya por lo menos un material en cada conjunto
		if (!materialesCond1.isEmpty() && !materialesCond2.isEmpty()) { 
			/*
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
			*/
			materialesSeleccionados.add(materialesCond1.anyOne())
			materialesSeleccionados.add(materialesCond2.anyOne())
		}
		return materialesSeleccionados
	}
	
	method buscarMateriales(_mochila)	
	
	method consecuencia(mochila, companiero, materiales)
	
	method puedeRealizarse(mochila) = !self.buscarMateriales(mochila).isEmpty()
	
	method realizar(mochila, companiero, estrategia) {
		if (self.puedeRealizarse(mochila)) {
			var materiales = estrategia.aplicarEstrategia(self, mochila) //obtengo los materiales de acuerdo a la estrategia
			mochila.removeAll(materiales)
			self.consecuencia(mochila, companiero, materiales)
		}
		else {
			self.error("No se puede realizar el experimento.")
		}
	}
}
/************************************************************/
object construirBateria inherits Experimento {
	const condMat1 = {m => m.grMetal() > 200}
	const condMat2 = {m => m.esRadioactivo()}
	
	override method buscarMateriales(mochila) = self.buscar2Materiales(mochila, condMat1, condMat2)
	
	override method consecuencia(mochila, companiero, materiales) {
		mochila.add(new Bateria(materiales))
		companiero.reducirEnergia(5)
	}
}
/************************************************************/
object construirCircuito inherits Experimento {
	
	override method buscarMateriales(mochila) = mochila.filter({m => m.conduceE() >= 5})
	
	override method consecuencia(mochila, companiero, materiales) {
		mochila.add(new Circuito(materiales))
	}
}
/************************************************************/
object shockElectrico inherits Experimento {
	const condMat1 = {m => m.generaE() > 0}
	const condMat2 = {m => m.conduceE() > 0}
	
	override method buscarMateriales(mochila) = self.buscar2Materiales(mochila, condMat1, condMat2)
	
	override method consecuencia(mochila, companiero, materiales) {
		companiero.recuperarEnergia(materiales.first().generaE() * materiales.last().conduceE())
	}
}