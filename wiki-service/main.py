from fastapi import FastAPI
from prometheus_client import Counter, generate_latest
from starlette.responses import Response

app = FastAPI()

users_created = Counter("users_created-total", "Total users Created")
posts_created = Counter("posts_created-total", "Total posts Created")

@app.post("/users/")
def create_user():
    users_created.inc()
    return {"status": "user created"}

@app.post("/posts/")
def create_post():
    posts_created.inc()
    return {"status": "posts created"}

@app.get("/metrics")
def metrics():
    return  Response(generate_latest(), media_type="text/plain")
