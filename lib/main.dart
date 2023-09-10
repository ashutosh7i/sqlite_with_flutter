import 'package:flutter/material.dart';

//1. importing dependencies
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:sqlite_with_flutter/Pages/AddNewContact.dart';

//2. defining data model
class Contact {
  final int id;
  final String name_surname;
  final int phoneNumber;
  final String email;
  final String notes;

  const Contact({
    required this.id,
    required this.name_surname,
    required this.phoneNumber,
    required this.email,
    required this.notes,
  });

//6. converting Contact into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_surname': name_surname,
      'phoneNumber': phoneNumber,
      'email': email,
      'notes': notes,
    };
  }

//6.A Implement toString to make it easier to see information about each contact when using print statement
  @override
  String toString() {
    return 'Contact{id: $id, name: $name_surname, phoneNumber: $phoneNumber, email: $email, notes: $notes}';
  }
}

//3. modify main method to async and open the DB connection
void main() async {
//4. opening the database
  //prevents errors on flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'doggie_database.db'),

//5. creating the table
    // When the database is first created, create a table to store contacts.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name_surname TEXT, phoneNumber INTEGER, email TEXT, notes TEXT)',
      );
    },
    //this version is for database upgrades in future, leave as it is
    version: 1,
  );

//7. Define a function that inserts contacts into the database
  Future<void> insertDog(Contact contact) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Contact into the correct table.
    // `conflictAlgorithm` is used to update data when saved again with same name.

    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//8. Create a contact and add it to contacts table

  var Raju = const Contact(
    id: 0,
    name_surname: "Raju Rastogi",
    phoneNumber: 9993234999,
    email: 'test@mail.com',
    notes: 'raju got successful at last, you too will.',
  );

  await insertDog(Raju);

//9. Reading list of Contacts

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

//9.A. Now, use the method above to retrieve all the contactss.
  print(await contacts()); // Prints a list that include Raju.

//10. Update a Contact in the database

//funciton to update a contact
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

//10.A updating raju's email and saving it.

  Raju = Contact(
    id: Raju.id,
    name_surname: Raju.name_surname,
    phoneNumber: Raju.phoneNumber,
    email: "newEmail@google.com",
    notes: Raju.notes,
  );

  await updateContact(Raju);

// Print the updated results.
  print(await contacts());

//11. Deleting a Contact in Database

//function to delete a contact from database
  Future<void> deleteContact(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Contact from the database.
    await db.delete(
      'contacts',
      // Use a `where` clause to delete a specific contact.
      where: 'id = ?',
      // Pass the Contact's to delete.
      whereArgs: [id],
    );
  }

//11.A. Delete contact .
  await deleteContact(1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Contact Manager"),
        centerTitle: true,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [],
      ),

      //floating action button to add new contact
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          // Within the `FirstRoute` widget
          onPressed: () {}),
    ));
  }
}
