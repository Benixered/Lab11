import com.google.gson.reflect.TypeToken
import com.github.kittinunf.fuel.core.ResponseDeserializable
import com.google.gson.Gson


data class Hero(val heroes: Array<Hero>, val name: String) {
    class HeroArrayDeserializer : ResponseDeserializable<Hero> {
        override fun deserialize(content: String): Hero {
            return Gson().fromJson(content, Hero::class.java)
        }


    }

}