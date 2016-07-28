module Bindings = struct

  type q_js_engine

  external init : unit -> q_js_engine = "qjs_ml_init"

  external evaluate : q_js_engine -> string -> string = "qjs_ml_eval_js"

  external garbage_collect : q_js_engine -> unit = "qjs_ml_garbage_collect"

  external evaluate_from_file : q_js_engine -> string -> string = "qjs_ml_eval_from_file"

  external set_property : q_js_engine -> string -> string -> unit = "qjs_ml_set_property"

end

exception JavaScript_eval_exn of {reason : string;
                                  line_number: int;
                                  stack : string;}

let () =
  Callback.register_exception
    "eval_exn"
    (JavaScript_eval_exn {reason = ""; line_number = 0; stack = ""})

class virtual_machine = object
  val ptr = Bindings.init ()
  method eval = Bindings.evaluate ptr
  method load_from_file = Bindings.evaluate_from_file ptr
  method garbage_collect = Bindings.garbage_collect ptr
  method set_global_property prop_name prop_value =
    Bindings.set_property ptr prop_name prop_value

end
