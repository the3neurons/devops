import pytest
from app import app

@pytest.fixture
def client():
    app.config["TESTING"] = True
    return app.test_client()

def test_predict_cat(client, monkeypatch):
    monkeypatch.setattr("app.model.predict", lambda x: [0])
    resp = client.post("/predict", json={"data": "meow"})
    assert resp.json == {"prediction": "cat"}

def test_predict_dog(client, monkeypatch):
    monkeypatch.setattr("app.model.predict", lambda x: [1])
    resp = client.post("/predict", json={"data": "woof"})
    assert resp.json == {"prediction": "dog"}
