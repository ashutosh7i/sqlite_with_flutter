# sqlite_with_flutter

This App is intended to demonstrate CRUD operations with SQLite in Flutter.

## SQLite

SQLite is a Lightweight, Serverless, Self-Contained, ACID-compliant database software library that can be used in embedded softwares to make self contained data Storage.

## SQFLite

Flutter apps can make use of the SQLite databases via the `sqflite` plugin available on pub.dev.

### Contact app

For easier understanding let's make a contact app using flutter and Sqflite, implementing a Contant app will include Create Read Update Delete operations.

## Getting Started

1. Initialize a new Flutter Application.
2. Add the dependencies
   `flutter pub add sqflite path`
   and import package.

3. Define the Data Mode

   A database should be precise and discriptive about its requirements, Like what needs to be stored.

   we are making a contact app, its task will be to CRUD contacts

   what we want to store? we want to store->

   0. new contact id
   1. new contact name_surname
   2. new contact phoneNumber
   3. new contact email.
   4. new contact notes.

   SQFLite used a class based model, lets make a class based model for this.

    ```dart
    class Contact {
       //here we are defining them
      final int id;
      final String name_surname;
      final int phoneNumber;
      final String email;
      final String notes;

       //here we are initializing them
      const Contact({
        required this.id,
        required this.name_surname,
        required this.phoneNumber,
        required this.email,
        required this.notes,
      });
   }
   ```

4. Open the database

   in this step we are opening the database for transaction.

   this is a async await code, and should be placed inside main, so we have to make the main method async.
   this is the modified main method with async-

   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();

   // Open the database and store the reference.
     final database = openDatabase(
       // Set the path to the database.
       join(await getDatabasesPath(), 'contacts_database.db'),
     );

     runApp(const MyApp());
   }
   ```

5. Create the contacts table
   Now we will create a table to store various contacts,
   the name in dart String will be stored as TEXT in Sqlite
   the number in dart is int, will be stored as INTEGER in sqlite.

   from our previous code, Contact will act as an individual object containing an id,name,number,email,notes etc,
   It will be represented as 5 tables in the contacts table
   Remember contacts is table, Contact is an item.

   ```dart
   //all code below goes after openDatabases() in main function itself.

   onCreate: (db, version) {
         // Run the CREATE TABLE statement on the database.
         return db.execute(
           'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name_surname     TEXT, phoneNumber INTEGER, email TEXT, notes TEXT)',
         );
       },
       //this version is for database upgrades in future, leave as it is
       version: 1,
   ```

6. Insert a contact into the database
   Now table is created, lets insert a Contact into the contacts table
   it is a two step process-

   1. Convert Contact into a Map.
   2. use a insert() method to store Map in contacts table.
   3. construct a string for easy printing in console.

    ```dart
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name_surname': name_surname,
        'phoneNumber' : phoneNumber,
        'email' : email,
        'notes' : notes,
      };
      ```

6.A. Implement toString to make it easier to see information about each contact when using print statement.

          ```
            @override
            String toString() {
              return 'Contact{
                id: $id,
                name: $name_surname,
                phoneNumber: $phoneNumber,
                email: $email,
                notes: $notes
                }';
            }
          ```
7. Define a function that inserts contacts into the database

    ```dart
      Future<void> insertDog(Contact contact) async {
        // Get a reference to the database.
        final db = await database;

        // Insert the Contact into the correct table.
        // `conflictAlgorithm` is used to update data when saved again with     same name.

        await db.insert(
          'contacts',
          contact.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    ```

C-

8. create a Contact and add it to contacts table

    ```dart
    //8. Create a contact and add it to contacts table

      var Raju = const Contact(
          id: 0,
          name_surname : "Raju Rastogi",
          phoneNumber : 9993234999,
          email : 'test@mail.com',
          notes : 'raju got successful at last, you too will.',
      );

      await insertDog(Raju);
    ```

R- 9. Reading list of Contacts

1. run a query against contacts table, it will return a List<Map>.
2. convert this into a List<Contact>.

    ```dart

      // A method that retrieves all the contacts from the contacts table.
      Future<List<Contact>> contacts() async {
        // Get a reference to the database.
        final db = await database;

        // Query the table for all The contacts.
        final List<Map<String, dynamic>> maps = await db.query('contacts');

        // Convert the List<Map<String, dynamic> into a List<Contact>.
        return List.generate(maps.length, (i) {
          return Contact(
            id: maps[i]['id'],
            name_surname: maps[i]['name_surname'],
            phoneNumber: maps[i]['phoneNumber'],
            email: maps[i]['email'],
            notes: maps[i]['notes'],
          );
        });
      }
    ```
9.A. Now, use the method above to retrieve all the contactss.

    ```
      print(await contacts()); // Prints a list that include Raju.
    ```

10. Update a Contact in the database
    1. convert Contact to a Map.

    ```dart
      Future<void> updateContact(Contact contact) async {
        // Get a reference to the database.
        final db = await database;

        // Update the given Contact.
        await db.update(
          'contacts',
          contact.toMap(),
          // Ensure that the Contact has a matching id.
          where: 'id = ?',
          // Pass the Contact's id for identification.
          whereArgs: [contact.id],
        );
      }
    ```

10.A updating raju's email and saving it.

    ```dart
    Raju = Contact(
        id: Raju.id,
        name_surname: Raju.name_surname,
        phoneNumber: Raju.phoneNumber,
        email: "newEmail@google.com",
        notes: Raju.notes,
      );
    
      await updateContact(Raju);
    ```
