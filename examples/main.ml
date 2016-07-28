
let () =
  let force () =
    let a = new QJSEngine.virtual_machine in
    a#eval "(function(){return 4 + 10;})" |> print_endline;
    a#garbage_collect;
  in
  force ();
  Gc.major ();

  let b = new QJSEngine.virtual_machine in
  b#load_from_file "examples/render.js" |> print_endline
