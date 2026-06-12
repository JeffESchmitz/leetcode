// Command lc scaffolds LeetCode problems into this Go workspace.
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	noOpen := flag.Bool("no-open", false, "don't open GoLand")
	noTest := flag.Bool("no-test", false, "don't run the failing test after scaffold")
	force := flag.Bool("force", false, "overwrite an existing problem folder")
	flag.Parse()

	if flag.NArg() != 1 {
		fmt.Fprintln(os.Stderr, "usage: lc <daily | url | number | slug> [--no-open] [--no-test] [--force]")
		os.Exit(2)
	}
	_ = noOpen
	_ = noTest
	_ = force
	fmt.Println("lc: not implemented yet, arg =", flag.Arg(0))
}
