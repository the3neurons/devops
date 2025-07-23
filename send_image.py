import requests

url = "https://app-ckpjkale.scm.azurewebsites.net/api/deployments/646b6cff-69be-4a3b-844c-5957f5fe55de/predict"
files = {"image": ("image.jpg", open("image.jpg", "rb"), "image/jpeg")}
response = requests.post(url, files=files)
print(response)