import pytest
from unittest.mock import patch
import sys
import os

# Make sure the app module is importable
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import app

@pytest.fixture
def client():
    app.testing = True
    return app.test_client()

def test_healthz(client):
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.data.decode("utf-8") == "OK"

@patch("app.get_openai_client")
def test_ask_api(mock_get_client, client):
    mock_create = mock_get_client.return_value.chat.completions.create
    mock_create.return_value.choices = [
        type("obj", (object,), {"message": type("msg", (object,), {"content": "Mocked response"})})
    ]

    response = client.post("/ask", json={"prompt": "Hello?"})
    data = response.get_json()

    assert response.status_code == 200
    assert data["response"] == "Mocked response"

def test_ask_api_missing_prompt(client):
    response = client.post("/ask", json={})
    data = response.get_json()

    assert response.status_code == 400
    assert data["error"] == "Missing prompt"
