module Bindings = struct

  type q_js_engine

  external init : unit -> q_js_engine = "qjs_ml_init"

  external evaluate : q_js_engine -> string -> string = "qjs_ml_eval_js"

  external garbage_collect : q_js_engine -> unit = "qjs_ml_garbage_collect"

  external evaluate_from_file : q_js_engine -> string -> string = "qjs_ml_eval_from_file"

end

(** A virtual machine creates a JavaScript execution environment. *)
class virtual_machine = object

  val ptr = Bindings.init ()

  (** Evaluate the given JavaScript script and result back the result
      as if calling toString on the result *)
  method eval = Bindings.evaluate ptr

  (** Evaluate the given JavaScript file and result back the last
      evaluated expression as a string *)
  method load_from_file = Bindings.evaluate_from_file ptr

  (** Runs the garbage collector in the JavaScript environment *)
  method garbage_collect = Bindings.garbage_collect ptr

end
