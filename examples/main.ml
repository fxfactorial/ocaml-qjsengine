
let () =
  let force () =
    let a = new QJSEngine.virtual_machine in
    try
      a#eval "var 10" |> ignore;
    with
      QJSEngine.JavaScript_eval_exn _ ->
      print_endline "JS Fucked up"
    (* a#eval "(function(){return 4 + 10;})" |> print_endline; *)

  in
  force ();
  Gc.major ();

  let b = new QJSEngine.virtual_machine in
  b#load_from_file "examples/render.js" |> print_endline

let () =
  let vm = new QJSEngine.virtual_machine in
  vm#set_global_property "name" "Edgar";
  vm#eval "this.name" |> print_endline
