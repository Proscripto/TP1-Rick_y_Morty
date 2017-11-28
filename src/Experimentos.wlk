import Materiales.*
import Estrategias.*

/************************************************************/
class Experimento {
	var condiciones
	
	constructor(condMat1) { condiciones = [condMat1] }
	constructor(condMat1, condMat2) { condiciones = [condMat1, condMat2] }
	
	
	method buscar1Material(unaPersona, condMat1){
		var setCondMat1 = unaPersona.mochila().filter(condMat1)
		var respuesta = []
		if (!setCondMat1.isEmpty()) {
			respuesta.add(unaPersona.estrategia().aplicarEstrategia(setCondMat1))
		}
		return respuesta
	}
	method buscar2Materiales(unaPersona, condMat1, condMat2){
		var setCondMat1 = unaPersona.mochila().filter(condMat1)
		var setCondMat2 = unaPersona.mochila().filter(condMat2)
		var respuesta = []
		if (!setCondMat1.isEmpty() && !setCondMat2.isEmpty()) {
			respuesta.add(unaPersona.estrategia().aplicarEstrategia(setCondMat1))
			respuesta.add(unaPersona.estrategia().aplicarEstrategia(setCondMat2))
		}
		return respuesta
	}
	
	method buscarMateriales(unaPersona)	{
		if (condiciones.size() == 1){
			return self.buscar1Material(unaPersona, condiciones.first())
		}
		else if (condiciones.size() == 2){
			return self.buscar2Materiales(unaPersona, condiciones.first(), condiciones.last())
		}
		else {
			return []
		}
	}
	
	method consecuencia(unaPersona, materiales)
	
	method puedeRealizarse(unaPersona) = !self.buscarMateriales(unaPersona).isEmpty()
	
	method realizar(unaPersona) {
		if (self.puedeRealizarse(unaPersona)) {
			var materiales = self.buscarMateriales(unaPersona) 
			unaPersona.mochila().removeAll(materiales)
			self.consecuencia(unaPersona, materiales)
		}
		else {
			self.error("No se puede realizar el experimento.")
		}
	}
}
/************************************************************/
object construirBateria inherits Experimento({m => m.grMetal() > 200}, { m => m.esRadioactivo() }) {
	
	override method consecuencia(unaPersona, materiales) {
		unaPersona.mochila().add(new Bateria(materiales))
		unaPersona.companiero().reducirEnergia(5)
	}
}
/************************************************************/
object construirCircuito inherits Experimento({m => m.conduceE() >= 5}) {
	
	override method consecuencia(unaPersona, materiales) {
		unaPersona.mochila().add(new Circuito(materiales))
	}
}
/************************************************************/
object shockElectrico inherits Experimento({m => m.generaE() > 0}, {m => m.conduceE() > 0}) {
	
	override method consecuencia(unaPersona, materiales) {
		unaPersona.companiero().recuperarEnergia(materiales.first().generaE() * materiales.last().conduceE())
	}
}