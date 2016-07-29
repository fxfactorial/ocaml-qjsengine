let () =
  let force () =
    let a = new QJSEngine.virtual_machine in
    try
      a#eval "var 10" |> ignore;
    with
      QJSEngine.JavaScript_eval_exn {reason; line_number; stack} ->
      Printf.sprintf
        "JavaScript Evaluation failed at line: %d because: %s, %s"
        line_number reason stack
    |> print_endline;
    a#eval "(function(){return 4 + 10;})" |> print_endline;
  in
  force ();
  Gc.major ();
  let b = new QJSEngine.virtual_machine in
  b#load_from_file "examples/render.js" |> print_endline

let () =
  let vm = new QJSEngine.virtual_machine in
  vm#set_global_property "name" "Edgar";
  vm#eval "this.name" |> print_endline

(* let () = *)
(*   let value = new QJSEngine.jsvalue () in *)
(*   Printf.sprintf "is bool %s" (if value#is_bool then "yes" else "no") *)
(*   |> print_endline *)

(* let () = *)
(*   let value = *)
(*     new QJSEngine.jsvalue ~with_value:(String "Hello World") () *)
(*   in *)
(*   Printf.sprintf "is bool %s" (if value#is_bool then "yes" else "no") *)
(*   |> print_endline *)

let () =
  let module JSArray = QJSEngine.Make(struct
                                       
                           
                                     end)
  in
  ()
