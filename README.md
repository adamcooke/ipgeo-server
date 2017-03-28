# IPGeo Server

This is a simple micro service that exposes a MaxMind database over a database. This allows the database to be easily shared between applications without the need to update the database in multiple places.

A suitable database should be made available and the path to it set in `MMDB_PATH` (by default, it is the root of the application).

## Usage

```text
$ bundle install --deployment
$ bundle exec rackup
```

## Requests

You can simply make get requests to the application with the IP address in the path.

```text
> GET /185.22.208.2
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 162
<
< {
<   "ip":"185.22.208.3",
<   "country":"GB",
<   "country_name":"United Kingdom",
<   "city":null,
<   "latitude":51.4964,
<   "longitude":-0.1224,
<   "geoname_id":2635167
< }
```

### Response Codes

* `200 OK` - IP address was found (data in the body)
* `404 Not Found` - the IP address was not the the database or malformed
* `403 Unauthorized` - the request came from an unauthorized IP

### Restricting Access

You may (should) restrict access access to specific networks by providing a list of network addresses in the `AUTHORIZED_NETS` environment variable.
