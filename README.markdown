Control a JavaScript execution environment in OCaml
==========================================================

These are OCaml bindings to
[QJSEngine](http://doc.qt.io/qt-5/qjsengine.html), aka Qt's own
JavaScript engine based off of Google's Blink engine.

Why
===

Controlling JavaScript is incredibly useful and there are some ideas I
have to play with this, like automatically converting between
JavaScript objects and OCamls. My motivating usecase was making an
OCaml server with separate JavaScript vms running for each route, each
loaded with ReactJS. Then per parametrized request, rendering a
different payload with ReactJS.

Installation
==============

At the moment the build is known to work on `OS X` and Ubuntu
Trusty. You can install with:

```shell
$ opam pin add -y qjsengine git@github.com:fxfactorial/ocaml-qjsengine.git
```

You'll need `qt5` installed, very easy with `brew install qt5` and
opam's external depedency handler, `depext`, should take care of it
for you.

If you're on Ubuntu trusty then simply doing: 

```shell
$ opam depext qjsengine
```

Should install the appropriate Qt libraries, note this will use a
`ppa` and install `Qt5.7`.

For other versions of Ubuntu look at
[this](https://launchpad.net/~beineri) ppa for Qt5 installation.

Examples
=========

The API is purposefully spare and high level at the moment. You
interact with it by creating a JavaScript virtual machine and
evaluating scripts in it. After evaluating the JavaScript, the value
you receive is the value of the last expression evaluated. If the
JavaScript side raises an exception while evaluating the script then
the OCaml side will raise as well.

If everything installed correctly then any example can be compiled
with: `ocamlfind ocamlopt -package qjsengine code.ml -o T`


```ocaml
let () =
  let vm = new QJSEngine.virtual_machine in
    try
	  (* This will raise because it is a syntax error *)
      vm#eval "var 10" |> ignore;
    with
      QJSEngine.JavaScript_eval_exn {reason; line_number; stack} ->
      print_endline "JS messed up"
```

You can also set global values and in this way can parameterize your
scripts by first setting some globals.

```ocaml
let () =
  let vm = new QJSEngine.virtual_machine in
  vm#set_global_property "name" "Edgar";
  vm#eval "this.name" |> print_endline (* prints Edgar *)
```

Documentation
===============

```ocaml
(** QJSEngine is the Qt project's JavaScript execution engine. You
    interact with it by creating a virtual machine and evaluating
    JavaScript within a virtual machine. Each virtual machine is a
    separate execution context and you can have as many as you want *)

(** Raised whenever there is an error in the evaluation of
    JavaScript *)
exception JavaScript_eval_exn of { reason : string;
                                   line_number : int;
                                   stack : string; }

(** A virtual machine creates a JavaScript execution environment,
    evaluating JavaScript code can raises exceptions when the
    JavaScript itself raises an exception *)
class virtual_machine : object

  (** Evaluate the given JavaScript script and result back the
      result as if calling toString on the result *)
  method eval : string -> string

  (** Runs the garbage collector in the JavaScript environment *)
  method garbage_collect : unit

  (** Evaluate the given JavaScript file and result back the last
      evaluated expression as a string *)
  method load_from_file : string -> string

  (** Sets a global value on the global value in this virtual
      machine. This global value will be visible to the scripts
      evaluated in this virtual machine *)
  method set_global_property : string -> string -> unit
end
```
