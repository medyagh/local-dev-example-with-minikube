package main

import (
	"fmt"
	"net/http"
)

var version = "0.0.1"

func indexHandler(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "<h1>hello world </h1> \n Version %s\n", version)
}

func headersHandler(w http.ResponseWriter, req *http.Request) {

	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

func main() {

	http.HandleFunc("/", indexHandler)
	http.HandleFunc("/headers", headersHandler)
	fmt.Printf("Starting example version %s Listening on port 8080 ...", version)
	http.ListenAndServe(":8080", nil)
}
