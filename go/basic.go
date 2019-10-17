package main

import (
	"fmt"
	"math"
)

func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	}
	return lim
}

// structure
type Point struct {
	X, Y int
}

func main() {
	// local variable
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
	p1 := &v //pointer
	p1.X = 4
	fmt.Println(v)

	//array
	primes := [5]int{2, 3, 5, 7, 11}
	fmt.Println(primes)

	//maps
	var m = make(map[string]Point)
	m["a"] = Point{3, 4}
	m["b"] = Point{5, 7}

	fmt.Println(m)

	//function ?
	hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
	}
	fmt.Println(hypot(5, 12))

	//function
	fmt.Println(pow(3, 2, 10))

	// Methods <- a function with a receiver argument

}
