Control a JavaScript execution environment in OCaml
==========================================================

These are OCaml bindings to
[QJSEngine](http://doc.qt.io/qt-5/qjsengine.html), aka Qt's own
JavaScript engine.


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

At the moment the build only works on `OS X` and can be done via:

```shell
$ opam pin add -y qjsengine git@github.com:fxfactorial/ocaml-qjsengine.git
```

You'll need `qt5` installed, very easy with `brew install qt5` and
opam's external depedency handler, `dep-ext`, should take care of it
for you.

Getting this to work on Linux is pretty straightforward, just have to
spend some time with the build system.

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
