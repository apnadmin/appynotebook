mysqldump --no-data --user=bitlooter --password=bitlooter --host=localhost  appynotebook  > /home/bitlooter/Desktop/tables.sql
mysqldump --no-data --user=bitlooter --password=bitlooter --host=localhost --routines appynotebook  > /home/bitlooter/Desktop/stored-procedures.sql


mysqldump  --user=bitlooter --password=bitlooter --host=localhost  appynotebook  roles > /home/bitlooter/Desktop/user-roles.sql

mysqldump  --user=bitlooter --password=bitlooter --host=appynotebook.com  appynotebook  text_data > /home/bitlooter/Desktop/text-data.sql
