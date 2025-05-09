import mysql.connector
from mysql.connector import Error
import os

def get_db_connection():
    """Função que retorna uma conexão com o banco de dados MySQL."""
    try:
        # Logs para debug (sem valores padrão)
        print("Tentando conectar ao MySQL com as seguintes configurações:")
        print(f"Host: {os.getenv('DATABASE_HOST')}")
        print(f"User: {os.getenv('DATABASE_USER')}")
        print(f"Database: {os.getenv('DATABASE_NAME')}")
        print(f"Port: {os.getenv('DATABASE_PORT', '3306')}")  # Porta padrão do MySQL é aceitável
        
        conn = mysql.connector.connect(
            host=os.getenv('DATABASE_HOST'),
            user=os.getenv('DATABASE_USER'),
            password=os.getenv('DATABASE_PASSWORD'),
            database=os.getenv('DATABASE_NAME'),
            port=int(os.getenv('DATABASE_PORT', '3306')),  # Porta padrão do MySQL é aceitável
            auth_plugin='mysql_native_password'
        )
        print("Conexão com o MySQL estabelecida com sucesso!")
        return conn
    except Error as err:
        print(f"Erro ao conectar ao MySQL: {err}")
        raise

def get_user_by_username(username: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        query = "SELECT username, password_hash FROM users WHERE username = %s"
        cursor.execute(query, (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        return user
    except Error as err:
        print(f"Erro ao buscar usuário: {err}")
        return None