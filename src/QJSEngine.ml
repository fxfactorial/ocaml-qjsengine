module Bindings = struct

  module Engine = struct
    type t

    external init : unit -> t = "qjs_ml_init"

    external evaluate : t -> string -> string = "qjs_ml_eval_js"

    external garbage_collect : t -> unit = "qjs_ml_garbage_collect"

    external evaluate_from_file : t -> string -> string = "qjs_ml_eval_from_file"

    external set_property : t -> string -> string -> unit = "qjs_ml_set_property"

  end

  module JSValue = struct

    type t

    external init : unit -> t = "qjs_ml_jsvalue_init"

    (* external init_with_string : string -> t = "qjs_ml_jsvalue_with_string" *)
    (* external init_with_int : int -> t = "qjs_ml_jsvalue_with_int" *)
    (* external init_with_float : float -> t = "qjs_ml_jsvalue_with_float" *)
    (* external init_with_bool : bool -> t = "qjs_ml_jsvalue_with_bool" *)
    external is_bool : t -> bool = "qjs_ml_jsvalue_is_bool"
  end

end

exception JavaScript_eval_exn of {reason : string;
                                  line_number: int;
                                  stack : string;}

let () =
  Callback.register_exception
    "eval_exn"
    (JavaScript_eval_exn {reason = ""; line_number = 0; stack = ""})

type init_t = String of string
            | Int of int
            | Float of float
            | Bool of bool

class virtual_machine = object
  val ptr = Bindings.Engine.init ()
  method eval = Bindings.Engine.evaluate ptr
  method load_from_file = Bindings.Engine.evaluate_from_file ptr
  method garbage_collect = Bindings.Engine.garbage_collect ptr
  method set_global_property prop_name prop_value =
    Bindings.Engine.set_property ptr prop_name prop_value

end
and jsvalue ?(with_value : init_t option) () = object

  val ptr = match with_value with
      None -> Bindings.JSValue.init ()
    | Some v ->
  (* match v with *)
  (* | String s -> Bindings.JSValue.init_with_string s *)
  (* | Int i -> Bindings.JSValue.init_with_int i *)
  (* | Float f -> Bindings.JSValue.init_with_float f *)
  (* | Bool b -> Bindings.JSValue.init_with_bool b *)

      assert false

  method is_bool = Bindings.JSValue.is_bool ptr


end
