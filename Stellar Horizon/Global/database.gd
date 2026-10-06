extends Node

var db: SQLite
var db_name := "res://highscore.db"

func _ready():
    # Initialize the SQLite database
    db = SQLite.new()
    db.path = db_name
    db.open_db()

    var table_schema = {

        "id": {"data_type": "int", "primary_key": true, "auto_increment": true},
        "score": {"data_type": "int"}
    }

    db.create_table("scores", table_schema)
    db.close_db()

func save_score(final_score: int):
    db.open_db()
    db.insert_row("scores", {"score": final_score})
    db.close_db()

func get_leaderboard() -> Array:
    db.open_db()
    db.query("SELECT * FROM scores ORDER BY score DESC LIMIT 5;")
    var results = db.query_result
    db.close_db()
    return results

