from requests import Session
import jwt

session = Session()
public_key = session.get("http://localhost:4000/api/cert").json()['public_key']
print("public key: ", public_key)
encoded = session.get("http://localhost:4000/api/message").json()['jwt']
print("encoded message: ", encoded)



decoded = jwt.decode(encoded, public_key, algorithms=["RS256"])
print(decoded)