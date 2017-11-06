class Planeta {
	var habitantes=[]
	method poderPlaneta(){
		return self.sumaDePoderes(habitantes)
	}
	method agregarHabitante(tipo){
		habitantes.add(tipo)
	}
	method poseeUnaOrden(){
		return self.poderDeLosTresMasPoderosos() >= (self.poderPlaneta())/2
			
	}
	method losTresMasPoderosos(){
		return habitantes.sortBy({habitante,otroHabitante=>habitante.poder()>otroHabitante.poder()}).take(3)
	}
	method poderDeLosTresMasPoderosos(){
		return self.sumaDePoderes(self.losTresMasPoderosos())
	}
	method sumaDePoderes(lista){
		return lista.sum({habitante=>habitante.poder()})
	}
}
class Habitante {
	var valentia
	var inteligencia
	constructor (_valentia,_inteligencia){
		valentia=_valentia
		inteligencia=_inteligencia
	}
	method poder(){
		return valentia+inteligencia
	}
}

class Soldado inherits Habitante{
	var potenciaArma
	constructor (_valentia,_inteligencia,_potenciaArma)=super(_valentia,_inteligencia){
		potenciaArma=_potenciaArma
	}
	
	override method poder(){
		return super()+ potenciaArma
	}
	
}
class Maestro inherits Habitante {
		var midiclorianos
		var tipoMaestro
		var tiempoMaestro
		var potenciaSable
	constructor (_valentia,_inteligencia,_midiclorianos,_tipoMaestro,_tiempoMaestro,_potSable)=super(_valentia,_inteligencia){
		midiclorianos=_midiclorianos
		tipoMaestro=_tipoMaestro
		tiempoMaestro=_tiempoMaestro
		potenciaSable=_potSable
	}
	override method poder(){
		return super()+ tipoMaestro.poderMaestro(potenciaSable,tiempoMaestro)+ midiclorianos/1000
	}
	method suceso(valor){
		tipoMaestro.suceso(valor,self)
	}
	method cambiarTipoMaestro(nuevoTipoMaestro){
		tipoMaestro=nuevoTipoMaestro
		tiempoMaestro=0
	}
	method pasarUnDia(){
		tiempoMaestro+=1
	}
	method mostrarMaestro(){
		return tipoMaestro
	}

}

object jedi{
	var pazInterior
	method suceso(valor,maestro){
		pazInterior+=valor
		if(pazInterior<=0){
			maestro.cambiarTipoMaestro(sith)
			sith.nivelOdio(1000)
		}
		
	}
	method paz(pazInt){
		pazInterior=pazInt
	}
	method poderMaestro(potSable,tiempoMaestro){
		return potSable*tiempoMaestro
	}

}

object sith {
	var nivelDeOdio
	method suceso(valor,maestro){
		if(valor>nivelDeOdio){
			maestro.cambiarTipoMaestro(jedi)
		}
		else {
			nivelDeOdio*=1.1
		}
	}
	method poderMaestro(potSable,tiempoMaestro){
		return self.potenciaSable(potSable)+tiempoMaestro
	}
	method potenciaSable(potSable){
		return potSable*2
}
	method nivelOdio(valor){
		nivelDeOdio=valor
}
}

