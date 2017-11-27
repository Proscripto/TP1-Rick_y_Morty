import Materiales.*
import Estrategias.*

/************************************************************/
class Experimento {
	
	method buscarCiertosMateriales(_mochila, _condicion){
		return _mochila.filter(_condicion)
	}
	
	method buscarMateriales(unaPersona)	
	
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
object construirBateria inherits Experimento {
	const condMat1 = { m => m.grMetal() > 200 }
	const condMat2 = { m => m.esRadioactivo() }
	
	override method buscarMateriales(unaPersona){
		return unaPersona.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(unaPersona.mochila(), condMat1) ) +
				unaPersona.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(unaPersona.mochila(), condMat2) )
	}
	
	override method consecuencia(unaPersona, materiales) {
		unaPersona.mochila().add(new Bateria(materiales))
		unaPersona.companiero().reducirEnergia(5)
	}
}
/************************************************************/
object construirCircuito inherits Experimento {
	
	override method buscarMateriales(unaPersona){
		return unaPersona.mochila().filter({m => m.conduceE() >= 5})
	}
	
	override method consecuencia(unaPersona, materiales) {
		unaPersona.mochila().add(new Circuito(materiales))
	}
}
/************************************************************/
object shockElectrico inherits Experimento {
	const condMat1 = {m => m.generaE() > 0}
	const condMat2 = {m => m.conduceE() > 0}
	
	override method buscarMateriales(unaPersona){
		 return unaPersona.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(unaPersona.mochila(), condMat1) ) +
				unaPersona.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(unaPersona.mochila(), condMat2) )
	}
	
	override method consecuencia(unaPersona, materiales) {
		unaPersona.companiero().recuperarEnergia(materiales.first().generaE() * materiales.last().conduceE())
	}
}