# THREADS
Project for using FTP Storage as storage for drivers data


This project was whritten by Orekhov A.S. while working in AO NIIAS. At work I used JRuby program language. It was only example of code, nothing bigger. 

At introduction i want to tell about I would to talk about the motivation for the decision task.

Driver has an information, which locating on DataBase. If need to get info, we coild to ask by DataBase, but it so hard to do it many times in a row. So was creating idea to say driver write info to FTP Storage, which it has posibility to connect. Each time driver listeting FTP Storage to find some instructions to do, for example to put information in FTP Storage, for example and do it!

Because som drivers locating so far from current locating user, information transfer takes a lot of time. And if driver did not have time to finish the operation, i user Threads to to give an opportunity to finish work. If some threads are alive? more than 5 minutes, the thread must to die. Threads put in hash, whose keys are time in class Time and type int. Values are entity of Threads. 

Code for driver is locating in read_ftp_task.rb
Structure of instruction discribed by module ServiceHistory
