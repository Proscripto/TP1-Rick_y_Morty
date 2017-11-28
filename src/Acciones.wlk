
class Acciones {
	method ejecutar(companiero)
}

class EntregarMochila inherits Acciones{
	var aQuien
	
	constructor(_aQuien) { aQuien = _aQuien }
	
	override method ejecutar(companiero) { companiero.darObjetosA(aQuien) }
}
class DescartarElementoAlAzar inherits Acciones{
	override method ejecutar(companiero) {
  		if (!companiero.mochila().isEmpty()){
  			companiero.mochila().remove(companiero.mochila().anyOne())
  		}
  	}
}
class IncrementarEnergia inherits Acciones{
	var cuanto
	
	constructor(_cuanto) { cuanto = _cuanto }
	
	override method ejecutar(companiero) { companiero.recuperarEnergia(cuanto) }
}
class DecrementarEnergia inherits Acciones{
	var cuanto
	
	constructor(_cuanto) { cuanto = _cuanto }
	
	override method ejecutar(companiero) { companiero.reducirEnergia(cuanto) }
}
class RecolectarMaterialOculto inherits Acciones{
	var unMaterial
	
	constructor(_unMaterial) { unMaterial = _unMaterial }
	
	override method ejecutar(companiero) { companiero.recolectar(unMaterial) }
}