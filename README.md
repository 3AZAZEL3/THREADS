# THREADS
Проект для создания инструмента по складированию информации с сервера в FTP хранилище с помощью драйвера.

Проект создан и релизован Ореховым А.С. в приод работы в АО НИИАС. Проект реализован на языке JRuby в программной среде клиент-серверной системы Vector-M. Здесь представлен принцип работы драйвера данных, реализованного с помощью многопоточной обработки данных.

Для начала следует рассказать о мотивации к решению проблемы.

По каналу данных в буферное хранилище с помощью драйвера записыаются различные данные, которые приходят с внешних систем. Иногда требуется иметь доступ к исторической информации каналов в базе данных, но при этом довольно проблематично брать эту информацию из базы данных. Была предложена система складирования иформации в FTP хранилище в виде csv фвйлов. Чтобы передавать эту информацию по запросу пользователя (предполагается что информацию брать напрямую нет возможности), предлагается драйверу задавать запрос на информацию в виде файла инструкции, где передается кофигурация драйвера, к которому производится запрос и метод для исполнения. Инструкцию предлагается хранить с помощью определенного интерфейса на FTP хранилище. 

Принцип работы:
1. Драйвер обращается в FTP  хранилище и просматривает определенную директорию на предмет наличия зарпоса; 
2. Если в файле совпала конфигурация драйвера, то исполняется код, который прописан в файле;
3. После исполнения инструкции, файл с инструкцией удаляется;
4. Данные в буферном хранилище формируются в виде файлов формата .csv и сохраняются на ftp.

Предполагается что драйверов несколько и что инструкций было послано несколько. Для того,чтобы обработать все запросы, предлагается под каждую инструкцию создать определенный поток данных, чтобы залипании потока на одном процессе, другие процессы не пострадали. Если процесс длиться дольше 5 минут, то поток убивается. Все потоки сохраняются в глбальный хеш данных, глде ключом является время создания, а значением - сущность потока. Для очищения хеша предлагается удалять все записи о потоках старше 5 минут.

В файле read_ftp_task.rb описан код просмотра FTP хранилища на наличие инструкций и исполнения кода, а также код обработки потоков.
В файле ServiceFtp.rb описан метод для создания файлов инструкций.
