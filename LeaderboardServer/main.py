from flask import Flask
from db import Connection

from uuid import uuid1
from flask import request

from datetime import datetime

app = Flask(__name__)
db = Connection('game2048_leaderboard')

entry_db = db.entry

base_endpoint = "/leaderboard"

@app.post(base_endpoint)
def create_user():
    _id = str(uuid1().hex)

    content = dict(request.json)
    content.update({"_id": _id})

    result = entry_db.insert_one(content)
    if not result.inserted_id:
        return {"message": "Failed to insert"}, 500

    return {
        "message": "Success",
        "data": {
            "id": result.inserted_id
        }
    }, 200


@app.put("{}/<user_id>/".format(base_endpoint))
def add_entry(user_id):
    query = {
        "_id": user_id
    }

    entry = request.json
    entry["timestamp"] = datetime.now().isoformat()

    content = {"$push": {"entries": entry}}
    result = entry_db.update_one(query, content, upsert=True)

    if not result.matched_count:
        return {
            "message": "Failed to update. Record is not found"
        }, 404

    if not result.modified_count:
        return {
            "message": "No changes applied"
        }, 500

    return {"message": "Update success"}, 200

@app.get(base_endpoint)
def get_entries():
    entries = entry_db.find({})
    return {
        "data": list(entries)
    }, 200


if __name__ == "__main__":
    app.run(port=8887, debug=True)