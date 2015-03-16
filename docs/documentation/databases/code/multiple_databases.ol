outputPort Database2 {
Interfaces: DatabaseInterface
}

embedded {
Java:
        "joliex.db.DatabaseService" in Database2
}

