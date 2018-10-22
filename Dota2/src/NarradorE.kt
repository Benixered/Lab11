class NarradorE: Narrator
{
    override fun narration(event: String): String {
        when (event){
            "menu" -> {return """
                MENU:
                1. Kill event.
                2. Tower kill event.
            """.trimIndent()}

            "finalMenu" -> {return """
                MENU:
                1. Kill event.
                2. Tower kill event.
                3. Ancient kill.
            """.trimIndent()}
