import pytest
import requests

def test_healthcheck(base_url):
    response = requests.get(f"{base_url}/healthcheck")
    assert response.status_code == 200, f"Healthcheck failed: {response.json()}"
    assert response.json() == {"status": "OK"}, f"Unexpected healthcheck response: {response.json()}"

def test_register_success(base_url, user_credentials):
    response = requests.post(f"{base_url}/register", json=user_credentials)
    assert response.status_code == 201, f"Registration failed: {response.json()}"

def test_login_success(base_url, user_credentials):
    response = requests.post(f"{base_url}/login", json=user_credentials)
    assert response.status_code == 200, f"Login failed: {response.json()}"
    assert "token" in response.json(), "Token not found in response"

def test_login_failure(base_url, user_credentials):
    invalid_credentials = user_credentials.copy()
    invalid_credentials["password"] = "wrongpassword"
    response = requests.post(f"{base_url}/login", json=invalid_credentials)
    assert response.status_code == 400, f"Login should have failed: {response.json()}"

@pytest.mark.parametrize("endpoint", ["/movie/1", "/movie?id=1"])
def test_get_movie_valid(headers, base_url, endpoint):
    url = f"{base_url}{endpoint}"
    response = requests.get(url, headers=headers)

    assert response.status_code == 200
    json_data = response.json()
    assert json_data.get("movieId") == 1
    assert "title" in json_data
    assert isinstance(json_data.get("genres"), list)

def test_get_movie_invalid(headers, base_url):
    response = requests.get(f"{base_url}/movie/999999", headers=headers)

    assert response.status_code == 404
    assert response.json().get("error") == "Movie not found"

def test_get_rating_valid(headers, base_url):
    response = requests.get(f"{base_url}/rating/1", headers=headers)

    assert response.status_code == 200
    json_data = response.json()
    assert json_data.get("movieId") == 1
    assert isinstance(json_data.get("average_rating"), float)


def test_get_rating_invalid(headers, base_url):
    response = requests.get(f"{base_url}/rating/999999", headers=headers)

    assert response.status_code == 404
    assert response.json().get("error") == "No ratings found for this movie"

def test_get_link_valid(headers, base_url):
    response = requests.get(f"{base_url}/link/1", headers=headers)

    assert response.status_code == 200
    json_data = response.json()
    assert json_data.get("movieId") == 1
    assert "imdbId" in json_data
    assert "tmdbId" in json_data

def test_get_link_invalid(headers, base_url):
    response = requests.get(f"{base_url}/link/999999", headers=headers)

    assert response.status_code == 404
    assert response.json().get("error") == "Movie links not found"

def test_no_auth_movie(base_url):
    response = requests.get(f"{base_url}/movie/1")
    assert response.status_code == 401  
    assert response.json().get("error") == "Token is missing"
