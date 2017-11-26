import Experimentos.*
import Materiales.*

//**********************************************************************************
//----------------------  Busqueda de Materiales con Estrategias  -------------------
//**********************************************************************************
	
	//En esta parte se pide agregar un poquito de inteligencia en esa selección, configurando una
	//estrategia de selección. Esta estrategia debe poder ser cambiada en cualquier momento del
	//juego

object alAzar {
	
	//Se elige cualquier elemento de la mochila que cumple con el requisito
	method aplicarEstrategia(_experimento,_mochila){
		
		return _experimento.buscarMateriales(_mochila) 
		
		//traer el primero o devolver el primero de un sort de la lista en el buscarMateriales(mochila) de cada Experimento????????
		//mochila.filter(cond).first() 
		//return mochila.filter(cond).sort().first()
	}
}

object menorCantidadDeMetal{
	
	//de todos los elementos que cumplen el requisito, aquel que tiene la menor cantidad de metal
	method aplicarEstrategia(_experimento,_mochila){
		
		return _experimento.buscarMateriales(_mochila).min({m => m.grMetal()})
	
	}
}

object mejorGeneradorElectrico{
	
	//de todos los elementos que cumplen el requisito, aquel que produce la mayor cantidad de energía
	method aplicarEstrategia(_experimento,_mochila){
		
		return _experimento.buscarMateriales(_mochila).max({m => m.generaE()})
		
	}
}
object ecologico{
	
	//De entre todos los elementos que cumplen el requisito, intenta utilizar un ser vivo.
	//En caso de que ninguno lo sea, intenta usar un elemento que no sea radiactivo.
	method aplicarEstrategia(_experimento,_mochila){
		
		return _experimento.buscarMateriales(_mochila).find({m => m.estaVivo()}) or 
				_experimento.buscarMateriales(_mochila).find({m => !m.esRadioactivo()}) 
	}
}


