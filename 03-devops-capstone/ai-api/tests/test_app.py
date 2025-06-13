import pytest
from unittest.mock import patch, MagicMock
from app import app

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client

def test_index_get(client):
    res = client.get("/")
    assert res.status_code == 200

def test_index_post(client):
    with patch("app.OpenAI") as mock_openai:
        mock_instance = MagicMock()
        mock_instance.chat.completions.create.return_value.choices = [
            MagicMock(message=MagicMock(content="Hello from AI"))
        ]
        mock_openai.return_value = mock_instance

        res = client.post("/", data={"prompt": "Hello"})
        assert res.status_code == 200
        assert b"Hello from AI" in res.data

def test_ask_api(client):
    with patch("app.OpenAI") as mock_openai:
        mock_instance = MagicMock()
        mock_instance.chat.completions.create.return_value.choices = [
            MagicMock(message=MagicMock(content="Hello via API"))
        ]
        mock_openai.return_value = mock_instance

        res = client.post("/ask", json={"prompt": "Hi"})
        assert res.status_code == 200
        assert res.get_json()["response"] == "Hello via API"
