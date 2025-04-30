import pytest
import requests
import os
import uuid
from dotenv import load_dotenv

load_dotenv()

@pytest.fixture(scope="session")
def user_credentials():
    unique_email = f"wan{uuid.uuid4().hex[:8]}@example.com"
    return {
        "email": unique_email,
        "password": "testpassword",
    }

@pytest.fixture(scope="session")
def base_url():
    host = os.getenv("HOST", "localhost")
    port = "80"
    base_url = "http://{}:{}/v1".format(host, port)
    return base_url

@pytest.fixture(scope="session")
def auth_token(base_url, user_credentials):
    response = requests.post(f"{base_url}/login", json=user_credentials)
    assert response.status_code == 200, f"Login failed: {response.json()}"    
    return response.json().get("token")

@pytest.fixture(scope="session")
def headers(auth_token):
    return {"Authorization": f"Bearer {auth_token}"}