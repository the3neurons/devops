import requests

url = "https://app-ckpjkale.scm.azurewebsites.net/api/deployments/ed20775b-37e0-4768-8114-aeb161b22133/predict"
files = {"image": ("image.jpg", open("image.jpg", "rb"), "image/jpeg")}
response = requests.post(url, files=files)
print(response)