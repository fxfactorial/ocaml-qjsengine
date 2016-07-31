exception JavaScript_eval_exn of {reason : string;
                                  line_number: int;
                                  stack : string;}

let () =
  Callback.register_exception
    "eval_exn"
    (JavaScript_eval_exn {reason = ""; line_number = 0; stack = ""})

module Bindings = struct
  module rec Engine : sig
    type t
    external init : unit -> t = "qjs_ml_init"
    external evaluate : t -> string -> string = "qjs_ml_eval_js"
    external garbage_collect : t -> unit = "qjs_ml_garbage_collect"
    external evaluate_from_file : t -> string -> string = "qjs_ml_eval_from_file"
    external set_property : t -> string -> string -> unit = "qjs_ml_set_property"
  end = Engine
end

class virtual_machine = object
  val ptr = Bindings.Engine.init ()
  method eval = Bindings.Engine.evaluate ptr
  method load_from_file = Bindings.Engine.evaluate_from_file ptr
  method garbage_collect = Bindings.Engine.garbage_collect ptr
  method set_global_property prop_name prop_value =
    Bindings.Engine.set_property ptr prop_name prop_value

end
