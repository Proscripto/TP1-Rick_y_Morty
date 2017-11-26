import Materiales.*
import Estrategias.*

/************************************************************/
class Experimento {
	
	method buscarCiertosMateriales(_mochila, _condicion){
		
		return _mochila.filter(_condicion)
	}
	
	method buscarMateriales(rick)	
	
	method consecuencia(rick, materiales)
	
	method puedeRealizarse(rick) = !self.buscarMateriales(rick).isEmpty()
	
	method realizar(rick) {
		if (self.puedeRealizarse(rick)) {
			var materiales = self.buscarMateriales(rick) 
			rick.mochila().removeAll(materiales)
			self.consecuencia(rick, materiales)
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
	
	override method buscarMateriales(rick){
	
		return rick.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(rick.mochila(), condMat1) ) +
				rick.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(rick.mochila(), condMat2) )
	
	}
	
	override method consecuencia(rick, materiales) {
		rick.mochila().add(new Bateria(materiales))
		rick.companiero().reducirEnergia(5)
	}
}
/************************************************************/
object construirCircuito inherits Experimento {
	
	override method buscarMateriales(rick){
	
		return rick.estrategia().aplicarEstrategia( rick.mochila().filter({m => m.conduceE() >= 5}) )
		
	}
	
	override method consecuencia(rick, materiales) {
		rick.mochila().add(new Circuito(materiales))
	}
}
/************************************************************/
object shockElectrico inherits Experimento {
	const condMat1 = {m => m.generaE() > 0}
	const condMat2 = {m => m.conduceE() > 0}
	
	override method buscarMateriales(rick){
	
		 return rick.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(rick.mochila(), condMat1) ) +
				rick.estrategia().aplicarEstrategia( self.buscarCiertosMateriales(rick.mochila(), condMat2) )
	}
	
	override method consecuencia(rick, materiales) {
		rick.companiero().recuperarEnergia(materiales.first().generaE() * materiales.last().conduceE())
	}
}