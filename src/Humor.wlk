/**********Clases de Humor para Jerry***********/

class Humor {
	
	method puedeRecolectar(unPersonaje, _unMaterial)
	
	method recolectar(unPersonaje, _unMaterial){
		if(self.puedeRecolectar(unPersonaje, _unMaterial)){
			unPersonaje.mochila().add(_unMaterial)
			_unMaterial.descontarEnergia(unPersonaje)
			
		}
		else {
			self.error("No se pudo recolectar")
		}
	}
	
	method puedeRecibir(unPersonaje, unosMateriales)
}

object buenHumor inherits Humor {
	const capacidadMochila = 3
	
	override method puedeRecolectar(unPersonaje, _unMaterial){
		return ((unPersonaje.energia() >= _unMaterial.energiaNecesaria()) and (unPersonaje.mochila().size() < capacidadMochila))   //maximo 3 materiales a la vez. Idem a Morty
	}
	
	override method puedeRecibir(unPersonaje, unosMateriales) = ((unPersonaje.mochila().size() + unosMateriales.size()) < capacidadMochila)
}

object malHumor inherits Humor {
	const capacidadMochila = 1
	
	override method puedeRecolectar(unPersonaje, _unMaterial){
		return ((unPersonaje.energia() >= _unMaterial.energiaNecesaria()) and (unPersonaje.mochila().size() < capacidadMochila))
	}
	
	override method puedeRecibir(unPersonaje, unosMateriales) = ((unPersonaje.mochila().size() + unosMateriales.size()) < capacidadMochila)	
}

object sobreExcitado inherits Humor {
	const capacidadMochila = 6
	
	override method puedeRecolectar(unPersonaje, _unMaterial){
		return ((unPersonaje.energia() >= _unMaterial.energiaNecesaria()) and (unPersonaje.mochila().size() < 6))
	}
	
	override method recolectar(unPersonaje, _unMaterial){
		self.soltarTodoRandom(unPersonaje)
		super(unPersonaje, _unMaterial)
	}
	
	method soltarTodoRandom(unPersonaje){
		if ([true,false,false,false].anyOne()){
			unPersonaje.mochila().clear()
		}
	}
	
	override method puedeRecibir(unPersonaje, unosMateriales) = ((unPersonaje.mochila().size() + unosMateriales.size()) < capacidadMochila)
}