# qrencode

A minimal Docker image that serves QR codes as PNG images over HTTP.

Built on Alpine Linux with [qrencode](https://fukuchi.org/works/qrencode/) and busybox httpd. The image is deliberately small and simple — see [Limitations](#limitations).

## Run

```sh
docker run --rm -p 8080:8080 darkopetreski/qrencode:latest
```

## Usage

Send a GET request with the `data` query parameter:

```sh
curl "http://localhost:8080/cgi-bin/qr?data=https://example.com" -o qr.png
```

Open in a browser:

```
http://localhost:8080/cgi-bin/qr?data=https://example.com
```

The response is an `image/png` QR code for the given string. Spaces can be encoded as `%20` or `+`. All standard URL percent-encoding is supported. The decoded `data` value is limited to 400 characters.

### Error responses

| Condition | HTTP status |
|---|---|
| `data` parameter missing | `400 Bad Request` |
| `data` longer than 400 characters (after URL decoding) | `400 Bad Request` (`invalid QUERY_STRING`) |
| `qrencode` fails (e.g. input too long for any QR version) | connection closed with partial body |

## Build from source

```sh
docker build -t darkopetreski/qrencode:latest .
```

## Limitations

This image is intentionally minimal and suited for low-traffic, internal use only:

- **No worker pool.** busybox httpd forks a new process for every request. Under sustained load this will exhaust system resources quickly.
- **No HTTPS.** Run behind a reverse proxy (nginx, Caddy, etc.) if TLS is required.
