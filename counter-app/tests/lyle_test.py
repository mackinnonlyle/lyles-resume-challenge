import unittest

class TestDatabase(unittest.TestCase):
    def test_connection(self):
        # Test the connection to the database
        conn = connect_to_database()
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        result = cursor.fetchone()
        self.assertEqual(result, 1)
        print("Tested database connection: PASSED")
        cursor.close()
        conn.close()

    def test_insert(self):
        # Test the ability to insert records into the database
        conn = connect_to_database()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", ("John", "john@example.com"))
        conn.commit()
        cursor.execute("SELECT * FROM users WHERE name = %s AND email = %s", ("John", "john@example.com"))
        result = cursor.fetchone()
        self.assertEqual(result, ("John", "john@example.com"))
        print("Tested database insert: PASSED")
        cursor.execute("DELETE FROM users WHERE name = %s AND email = %s", ("John", "john@example.com"))
        conn.commit()
        cursor.close()
        conn.close()

    def test_retrieve(self):
        # Test the ability to retrieve records from the database
        conn = connect_to_database()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", ("John", "john@example.com"))
        conn.commit()
        cursor.execute("SELECT * FROM users WHERE name = %s AND email = %s", ("John", "john@example.com"))
        result = cursor.fetchone()
        self.assertEqual(result, ("John", "john@example.com"))
        print("Tested database retrieve: PASSED")
        cursor.execute("DELETE FROM users WHERE name = %s AND email = %s", ("John", "john@example.com"))
        conn.commit()
        cursor.close()
        conn.close()

    def test_update(self):
        # Test the ability to update records in the database
        conn = connect_to_database()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", ("John", "john@example.com"))
        conn.commit()
        cursor.execute("UPDATE users SET email = %s WHERE name = %s", ("john@example.com", "John"))
        conn.commit()
        cursor.execute("SELECT * FROM users WHERE name = %s AND email = %s", ("John", "john@example.com"))
        result = cursor.fetchone()
        self.assertEqual(result, ("John", "john@example.com"))
        print("Tested database update: PASSED")
        cursor.execute("DELETE FROM users WHERE name = %s AND email = %s", ("John", "john@example.com"))
        conn.commit()
       
