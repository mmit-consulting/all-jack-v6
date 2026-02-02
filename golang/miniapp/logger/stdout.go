package logger

import "fmt"

type Stdout struct{}

func (Stdout) Log(message string){
	fmt.Println(message)
}
