from azure.storage.blob import ContainerClient
import mysql.connector
import dotenv

dotenv.load_dotenv()

# Informations de connexion
connection_string = dotenv.get_key("AZURE_STORAGE_ACCOUNT_KEY")
container_name = dotenv.get_key("AZURE_CONTAINER_NAME")

# Créer le client du container
container_client = ContainerClient.from_connection_string(connection_string, container_name)

# connection base sql azure
conn = mysql.connector.connect(
    host=dotenv.get_key("MYSQL_HOST"),
    user=dotenv.get_key("MYSQL_USER"),
    password=dotenv.get_key("MYSQL_PASSWORD"),
    database=dotenv.get_key("MYSQL_DATABASE"),
)
cursor = conn.cursor()
# création de la table si elle n'existe pas
cursor.execute("""
CREATE TABLE IF NOT EXISTS urls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    url VARCHAR(255) NOT NULL
)
""")

# Lister tous les blobs récursivement
print("Liste des blobs dans le container :")
for blob in container_client.list_blobs():
    name = blob.name
    type = name.split("/")[0]
    url = container_client.get_blob_client(blob).url
    cursor.execute("""
    INSERT INTO urls (type, url) VALUES (%s, %s)
    """, (type, url))
    print(f"Type: {type}, URL: {url}")



cursor.close()
conn.close()
    
