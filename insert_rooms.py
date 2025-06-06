import mysql.connector

try:
    conn = mysql.connector.connect(
        host='34.118.232.14',
        user='user',
        password='user',
        database='mydb'
    )
    cursor = conn.cursor()
    
    insert_sql = """
    INSERT INTO rooms (name, capacity, location, available) VALUES
    ('Sala Alpha', 10, 'Bloco A, Andar 1', TRUE),
    ('Sala Beta', 15, 'Bloco A, Andar 2', TRUE),
    ('Sala de Reunião 1', 8, 'Bloco B, Andar 3', FALSE),
    ('Auditório Principal', 50, 'Bloco C, Térreo', TRUE);
    """
    
    cursor.execute(insert_sql)
    conn.commit()
    print('Inserção concluída com sucesso!')
    
except mysql.connector.Error as err:
    print(f'Erro: {err}')
finally:
    if 'cursor' in locals() and cursor is not None:
        cursor.close()
    if 'conn' in locals() and conn is not None and conn.is_connected():
        conn.close() 