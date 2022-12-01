package main

import (
	"fmt"
	"net/http"
)

func indexHandler(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "<h1>hello world</h1>\n")
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
	fmt.Println("Listening on port 8080 ...")
	http.ListenAndServe(":8080", nil)
}
