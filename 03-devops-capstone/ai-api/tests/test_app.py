# import pytest
# from flask.testing import FlaskClient
# from app import app

# @pytest.fixture
# def client():
#     app.config["TESTING"] = True
#     with app.test_client() as client:
#         yield client

# def test_index_page(client: FlaskClient):
#     response = client.get("/")
#     assert response.status_code == 200
#     assert b"<form" in response.data

# def test_ask_api(client: FlaskClient, monkeypatch):
#     class MockResponse:
#         def __init__(self):
#             self.choices = [type("obj", (object,), {"message": type("msg", (object,), {"content": "Mocked response"})()})]

#     def mock_create(*args, **kwargs):
#         return MockResponse()

#     def mock_openai_client():
#         class MockClient:
#             def __init__(self):
#                 self.chat = type("obj", (), {"completions": type("obj", (), {"create": mock_create})})()
#         return MockClient()

#     monkeypatch.setattr("app.get_openai_client", mock_openai_client)

#     response = client.post("/ask", json={"prompt": "Hello"})
#     assert response.status_code == 200
#     assert response.get_json()["response"] == "Mocked response"
