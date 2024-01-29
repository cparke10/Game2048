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
    print(content.get("name"))
    existing_user = entry_db.find_one({"name": content.get("name")})
    if existing_user is None:
        content.update({"_id": _id})

        result = entry_db.insert_one(content)
        if not result.inserted_id:
            return {"isSuccessful": False}, 500

        return {
            "isSuccessful": True,
            "data": {
                "id": result.inserted_id
            }
        }, 200
    else:
        return {
            "isSuccessful": True,
            "data": {
                "id": existing_user["_id"]
            }
        }, 200


@app.put("{}/<user_id>/".format(base_endpoint))
def add_entry(user_id):
    query = {
        "_id": user_id
    }

    entry = request.json
    entry["timestamp"] = datetime.utcnow().isoformat(timespec='seconds') + 'Z'

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
@app.get("{}/<user_id>".format(base_endpoint))
def get_entries(user_id=None):
    query = {} if user_id is None else {"_id": user_id}
    entries = entry_db.find(query)
    return {
        "data": list(entries)
    }, 200


if __name__ == "__main__":
    app.run(port=8887, debug=True)
