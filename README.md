# moduleScheme

# What is it?
This is a moduleScheme code. Basicly, whole this program is the core with some couple of template modules. The core itself just a communicator for all the modules. 
Modules themself made to work on different tasks. Like EFM made to deal with file system (create folders, create files, read and write them), User module made to describe user itself (user name, and ect.), baseModule sands for base for custom modules, Console is basicly just a unix-like terminal immitator, TermuxAPI is an Bash-API wrapper written on Ruby.
All modules divideds on Core modules and Custom modules. Core moduels are preinitialized in Core so nobody can add them. Custom modules are made to be created by user.

# What i need to do with it?

So, if u are using Termux on Android, you can automate user experience with it, because moduleScheme comes with TermuxAPI (in beta). Actually, i made it only for this, but found out that i can make it work on PC to automate it too.

# How does modules work?

Custom module is made from main module script, actual module's script(s) and manifest. The main script of the module must contain a class to be recognized by a Core (class must be parented from BaseModule class). Manifest is just a describe file for Core. Manifest itself contaians all the info about module, like name of the main script, name of addicitonal script(s) file(s), text info of a module (name, desc, author, version), functions that must be executed in Core's main loop, name of the module's class. Well, i preffer to name class of the module by it's folder, but it's not so important.

# What is the last version of it?

You can just download the repository, it itself is a last version.

# What OS'es are supported?

Only Linux and Andorid's Termux. You can port this mess if u really like it.
