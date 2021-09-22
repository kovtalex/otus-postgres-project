# otus-postgres-project

- подключение к cockroachdb

Прописать в /etc/hosts: <ip_ноды_кубера> cockroachdb-public

```bash
cockroach sql --certs-dir ./certs --host cockroachdb-public:30001
```

- создание базы и таблицы

```sql
create database taxi_trips;
use taxi_trips;

create table taxi_trips (
unique_key text, 
taxi_id text, 
trip_start_timestamp TIMESTAMP, 
trip_end_timestamp TIMESTAMP, 
trip_seconds bigint, 
trip_miles numeric, 
pickup_census_tract bigint, 
dropoff_census_tract bigint, 
pickup_community_area bigint, 
dropoff_community_area bigint, 
fare numeric, 
tips numeric, 
tolls numeric, 
extras numeric, 
trip_total numeric, 
payment_type text, 
company text, 
pickup_latitude numeric, 
pickup_longitude numeric, 
pickup_location text, 
dropoff_latitude numeric, 
dropoff_longitude numeric, 
dropoff_location text
);
```

- наполнение таблицы

```bash
export KEY=$(cat ~/gcp.json | base64)

for i in {10..49}
do
  echo "$i"; cockroach sql --certs-dir ./certs --host cockroachdb-public:30001 --database taxi_trips --execute="IMPORT INTO taxi_trips CSV DATA ('gs://taxi_trips_otus/taxi_trips_0000000000$i.csv?AUTH=specified&CREDENTIALS=${KEY}') WITH delimiter = ',', nullif = '', skip = '1'"
done
```

- создание индекса

```sql
CREATE INDEX idx_taxi_trip_miles ON taxi_trips(trip_miles);
```

- проверка таблицы

```sql
SELECT count(*) from taxi_trips;
```

- создание пользователя

```sql
CREATE USER alex WITH PASSWORD 'yfvr54d&6';
GRANT admin TO alex'
```

- настройка реплик

```sql
ALTER DATABASE taxi_trips CONFIGURE ZONE USING num_replicas = 9, gc.ttlseconds = 90000;
```

- сборка и пуш бекенда

```bash
docker build -t <username>/node-api-postgres:v0.1 .
docker push <username>/node-api-postgres:v0.1
```

- запуск нагрузочного тестирования

```bash
docker run --rm -v $(pwd)/tank:/var/loadtest -it direvius/yandex-tank
```
