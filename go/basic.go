package main

import (
	"fmt"
	"math"
)

//structure
type Point struct {
	X, Y int
}

func main() {
	i := 42

	// pointer
	p := &i //point to i

	// read i through pointer p
	fmt.Println(*p) //

	//set i through pointer p
	*p = 21
	fmt.Println(i)

	//structue
	v := Point{1, 2}
	v.X = 4
	fmt.Println(p)

	//array
	primes := [5]int{2, 3, 5, 7, 11}
	fmt.Println(primes)

	//maps
	var m = map[string]Point{
		"a": {3, 4},
		"b": {5, 7},
	}

	fmt.Println(m)

	//function ?
	hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
	}
	fmt.Println(hypot(5, 12))
}
