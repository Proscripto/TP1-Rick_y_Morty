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
	method aplicarEstrategia(_lista) = _lista.anyOne()
}

object menorCantidadDeMetal{
	//de todos los elementos de la lista, aquel que tiene la menor cantidad de metal
	method aplicarEstrategia(_lista) = _lista.min({m => m.grMetal()})
}

object mejorGeneradorElectrico{
	//de todos los elementos de la lista, aquel que produce la mayor cantidad de energía
	method aplicarEstrategia(_lista) = _lista.max({m => m.generaE()})
}
object ecologico{
	//De todos los elementos de la lista, intenta utilizar un ser vivo.
	//En caso de que ninguno lo sea, intenta usar un elemento que no sea radiactivo.
	method aplicarEstrategia(_lista) = (_lista.filter({m => m.estaVivo()}) + _lista.filter({m => !m.esRadioactivo()})).first()
}


