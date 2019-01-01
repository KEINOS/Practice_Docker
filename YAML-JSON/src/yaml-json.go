package main

// Ref:
//   https://qiita.com/arc279/items/0c6fd58e4c4dc52770b5 @ Qiita
// Get package:
//   `$ go get github.com/ghodss/yaml`
//   https://gopkg.in/yaml.v2
//   `$ go get gopkg.in/yaml.v2`
// Build app:
//   `$ go build yaml2json.go`

import (
    "flag"
    "fmt"
    "io/ioutil"
    "os"

    "encoding/json"
    "github.com/ghodss/yaml"
    yaml2 "gopkg.in/yaml.v2"
)

func main() {
    var (
        jsonFlag bool
        yamlFlag bool
    )
    flag.BoolVar(&jsonFlag, "json", false, "bool flag")
    flag.BoolVar(&yamlFlag, "yaml", false, "bool flag")
    flag.Parse()

    buf, err := ioutil.ReadAll(os.Stdin)
    if err != nil {
        panic(err)
    }

    m := make(map[string]interface{})
    err = yaml.Unmarshal(buf, &m)
    if err != nil {
        panic(err)
    }

    if yamlFlag {
        d, err := yaml2.Marshal(&m)
        if err != nil {
            panic(err)
        }
        fmt.Printf("%s", d)
    }

    if jsonFlag {
        d, err := json.Marshal(&m)
        if err != nil {
            panic(err)
        }
        fmt.Printf("%s", d)
    }
}