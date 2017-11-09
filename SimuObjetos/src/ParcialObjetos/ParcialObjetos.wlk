class NoPuedeSubirEsclavoConArmas inherits Exception{}
class NoSePuedeSubirMasDeEscala inherits Exception{}
class NoValeLaPena inherits Exception{}
class Expedicion{
	var listaExpedicionistas= #{}
	var lugaresAInvadir= #{}
	
	constructor (_lugaresAInvadir,_listaExpedicionistas){
		lugaresAInvadir=_lugaresAInvadir
		listaExpedicionistas=_listaExpedicionistas
	}
	
	method puedeIr(vikingo){ //punto de entrada
		if (vikingo.productivo()){
		listaExpedicionistas.add(vikingo)
		}
	}
	method valeLaPena(){
		if (lugaresAInvadir.all({aldeaOCapital=>aldeaOCapital.valeLaPena(listaExpedicionistas)})){
			listaExpedicionistas.forEach({expedicionistas=>expedicionistas.cobrarVida()})
			listaExpedicionistas.forEach({expedicionistas=>expedicionistas.cobrarOro(self.dividirRiquezas())})
			lugaresAInvadir.forEach({aldeaOCapita=>aldeaOCapital.quitarTodo()})
			return true
		}
		else{
			return false
		}
	}
	method realizarExpedicion(){
		if(self.valeLaPena()){
			self.dividirRiquezas()
		}
		else {
			throw new NoValeLaPena("No vale la pena esa expedición")
		}
			
		}
	method cantidadOroGanado(){
		return lugaresAInvadir.sum({aldeaOCapital=>aldeaOCapital.botin()})		
	}
	method dividirRiquezas(){
		return self.cantidadOroGanado()/self.cantidadExpedicionistas()
	}
	method cantidadExpedicionistas(){
		return listaExpedicionistas.size()
	}
}
class Capital{
	var defensores
	var factorRiqueza
	constructor(_factorRiqueza,_defensores){
		factorRiqueza=_factorRiqueza
		defensores=_defensores
	}
	method valeLaPena(expedicion){
		return (expedicion.cantidadExpedicionistas()/self.botin(expedicion))>=3
	}
	method botin(expedicion){
		return expedicion.cantidadExpedicionistas()+factorRiqueza
	}
	method quedanDefensores(expedicion){
		return (expedicion.cantidadExpedicionistas()-defensores).abs()
	}
	method quitarTodo(expedicion){
		factorRiqueza=0
		defensores=self.quedanDefensores(expedicion)
	}
} 
class Aldea{
	var cantidadCrucifijos
	constructor (_cantidadCrucifijos){
		cantidadCrucifijos=_cantidadCrucifijos
	}
	method valeLaPena(expedicion){
		return cantidadCrucifijos>=15
	}
	method botin()=cantidadCrucifijos
	method quitarTodo(){
		cantidadCrucifijos=0
	}
}
class Amurallada inherits Aldea{
	var cantidadMinimaDeVikingos
	constructor(_cantidadMinimaDeVikingos,_cantidadCrucifijos) = super (_cantidadCrucifijos){
		cantidadMinimaDeVikingos=_cantidadMinimaDeVikingos
	}
	override method valeLaPena(expedicion){
		return super(expedicion)&& expedicion.cantidadExpedicionistas()>=cantidadMinimaDeVikingos
	}
}

class Vikingo {
	var rol
	var casta
	var cantidadVidas
	var oro
	constructor(_rol,_casta,_cantidadVidas,_oro){
		rol=_rol
		casta=_casta
		oro=_oro
		cantidadVidas=_cantidadVidas
		}
	method productivo(){
		return rol.esProductivo(self) and casta.puedeIr(self)
	}
	method poseoArmas(valor){
		return self.rol().cantidadArmas()>valor
	}
	method cantidadVidasMayorA20(){
		return cantidadVidas>20
	}
	method cobrarVida(){
		cantidadVidas+=1
	}
	method subirEscala(){
		casta.subir(self)
	}
	method rol()=rol
	method cambiarCasta(castaNueva){
		casta=castaNueva
	}
	method casta()=casta
	method cobrarOro(valor){
		oro+=valor
	}
	method rolNuevo(_rol){
		rol=_rol
	}
}

class Soldado {
	var cantidadArmas
	constructor(_cantidadArmas){
		cantidadArmas=_cantidadArmas
	}
	method esProductivo(vikingo){
		return vikingo.cantidadVidasMayorA20() and vikingo.poseoArmas(1)
	}
	method cantidadArmas()=cantidadArmas
	method cambiarRol(vikingo){
		vikingo.rolNuevo(new Soldado(10))
	}
}

class Granjero {
	var cantidadHijos
	var hectareas
	constructor(_cantidadHijos,_hectareas){
		cantidadHijos=_cantidadHijos
		hectareas=_hectareas
	}
	method esProductivo(vikingo){
		return cantidadHijos % hectareas==0
	}
	method cantidadArmas()=0
	method cambiarRol(vikingo){
		vikingo.rolNuevo(new Granjero(2,2))
	}
}

object esclavo{
	method puedeIr(vikingo){
		if(!vikingo.poseoArmas(0)) {
			throw new NoPuedeSubirEsclavoConArmas("No puede subir esclavo con armas")
		}
	}	
	method subir(vikingo){
		vikingo.rol().cambiarRol(vikingo)
		vikingo.cambiarCasta(castaMedia)
	}
}

object castaMedia{
	method puedeIr(vikingo){
		return true
	}
	method subir(vikingo){
		vikingo.cambiarCasta(noble)
	}
}

object noble{
	method puedeIr(vikingo){
		return true
	}
	method subir(vikingo){
		return throw new NoSePuedeSubirMasDeEscala ("Los nobles no pueden subir mas de escala")
	}
}



//Pregunta teórica: Aparecen los castillos, que son un nuevo posible objetivo a invadir además de las aldeas y capitales. ¿Pueden agregarse sin modificar código existente? Explicar cómo agregarlo. Justificar conceptualmente.

//Si se quisiera agregar castillos como un  nuevo posible objetivo a invadir no modificaria el 
//codigo existente ya que si se genera una clase Castillos, si se la hace polimorfica junto con 
//Aldeas y Capitales que ya lo son mediante el método "vale la pena", no debería realizarse ningun cambio.
//Para agregar castillos se haria una clase, con un metodo llamado "vale la pena", como se menciono anteriormente,
//para mantener el polimorfimos y eso haría que en la lista de lugaresAInvadir habrian castillos y al realizar
// el metodo de si vale la pena la expedicion, funcionaria correctamente.



