import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

# Database configuration
db_config = {
    "host": "127.0.0.1",       # The server where your MySQL is running
    "user": "root",           # Your MySQL username
    "password": "yuval1991",  # The password for your MySQL user
    "database": "userdb"      # The name of your database
}

# Connect to the database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

def register(username, password):
    hashed_password = generate_password_hash(password, method='sha256')
    try:
        cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, hashed_password))
        conn.commit()
        return True
    except mysql.connector.IntegrityError:  # This will handle duplicate username entries
        return False

def login(username, password):
    cursor.execute("SELECT password FROM users WHERE username=%s", (username,))
    result = cursor.fetchone()
    if result and check_password_hash(result[0], password):
        return True
    return False

# Example usage
if register("testuser", "testpass"):
    print("Registered successfully!")
else:
    print("Username already exists!")

if login("testuser", "testpass"):
    print("Login successful!")
else:
    print("Invalid credentials!")
