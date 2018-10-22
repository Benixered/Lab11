
class NarradorS: Narrator {
    override fun narration(event: String): String {
        when (event){
            "menu" -> {return """
                MENU:
                1. Ocurrió una muerte.
                2. destruyeron una torre.
            """.trimIndent()}

            "finalMenu" -> {return """
                MENU:
                1. Ocurrió una muerte.
                2. destruyeron una torre.
                3. Mataron a un ancient.
            """.trimIndent()}

            "welcome" -> {return """
                Bienvenido!
                Es turno de seleccionar a tus heroes.
            """.trimIndent()}