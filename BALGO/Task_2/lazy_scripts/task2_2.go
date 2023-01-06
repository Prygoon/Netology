package main

import "fmt"

type print_results_type func([6]uint8) uint8

func first(bits [6]uint8) uint8 {
	a, b, c, d, e, f := bits[0], bits[1], bits[2], bits[3], bits[4], bits[5]

	// (a ∧ b) ∨ (c ∧ d) ∨ (e ∧ f)
	return (a & b) | (c & d) | (e | f)
}

func second(bits [6]uint8) uint8 {
	a, c, e := bits[0], bits[2], bits[4]

	// (a ∧ c) ∨ (c ∧ e) ∨ (e ∧ a)
	return (a & c) | (c & e) | (e & a)

}

func third(bits [6]uint8) uint8 {
	b, d, f := bits[1], bits[3], bits[5]

	// (b ∧ d) ∨ (d ∧ f) ∨ (f ∧ b)
	return (b & d) | (d & f) | (f & b)
}

func fourth(bits [6]uint8) uint8 {
	a, b, c, d, e, f := bits[0], bits[1], bits[2], bits[3], bits[4], bits[5]

	// (a ∧ d) ∨ (b ∧ e) ∨ (c ∧ f)
	return (a & d) | (b & e) | (c & f)
}

func print_results(bits [6]uint8, fn print_results_type) {
	fmt.Printf("%v ", fn(bits))
}

func main() {
	first_array := [6]uint8{1, 1, 0, 0, 0, 0}
	second_array := [6]uint8{1, 0, 1, 0, 0, 1}
	third_array := [6]uint8{1, 0, 0, 1, 0, 0}

	complete_array := [3][6]uint8{first_array, second_array, third_array}

	fmt.Printf("First:  ")
	for i := 0; i < 3; i++ {
		print_results(complete_array[i], first)
	}

	fmt.Printf("\nSecond: ")
	for i := 0; i < 3; i++ {
		print_results(complete_array[i], second)
	}

	fmt.Printf("\nThird:  ")
	for i := 0; i < 3; i++ {
		print_results(complete_array[i], third)
	}

	fmt.Printf("\nFourth: ")
	for i := 0; i < 3; i++ {
		print_results(complete_array[i], fourth)
	}
	fmt.Printf("\n")

}
