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
 * 	agotar(_energia)
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
	var mochila //maximo 3 materiales a la vez.
	
	method puedeRecolectar(_unMaterial){
		return energia >= _unMaterial.grMetal() and mochila.size() < 3
	}
	
	method recolectar(_unMaterial){
		if(self.puedeRecolectar(_unMaterial)){
			mochila.add(_unMaterial)
		}
		else
			self.error("no se pudo recolectar")
		
	}
	
	method darObjetosA(_unCompanero){//saca todas las cosas de su mochila y se las pasa a un compañero
	
	}
	
	method agotar(_energia){}
  	
  	method recuperar(_energia){}
	
}