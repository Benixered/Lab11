import com.github.kittinunf.fuel.Fuel
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction



fun main(args:Array<String>){
    val url = "https://raw.githubusercontent.com/kronusme/dota2-api/master/data/heroes.json"
    val (request, response, result) = Fuel.get(url).responseObject(Hero.HeroesArrayDeserializer())
    val (hero, err) = result

    println("""
        Que idioma desea para su anunciador:
            1. Español
            2. Ingles
    """.trimIndent())

    //Configurar el idioma del juego

