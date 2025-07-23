import requests

url = "https://your-api-endpoint.com/predict"
files = {"image": ("image.jpg", open("image.jpg", "rb"), "image/jpeg")}
response = requests.post(url, files=files)