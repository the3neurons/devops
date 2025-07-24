import requests
import json
url = "http://app-ckpjkale.azurewebsites.net/predict"
files = {"image": ("image.jpg", open("image.jpg", "rb"), "image/jpeg")}
response = requests.post(url, files=files)
print(str(response))