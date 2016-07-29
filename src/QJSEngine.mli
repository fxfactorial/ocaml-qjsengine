(** QJSEngine is the Qt project's JavaScript execution engine. You
    interact with it by creating a virtual machine and evaluating
    JavaScript within a virtual machine. Each virtual machine is a
    separate execution context and you can have as many as you want *)

(** Raised whenever there is an error in the evaluation of
    JavaScript *)
exception JavaScript_eval_exn of { reason : string;
                                   line_number : int;
                                   stack : string; }

(** Different OCaml values you can use to create a new {b jsvalue} *)
type init_t =
    String of string | Int of int | Float of float | Bool of bool

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

and jsvalue : ?with_value:init_t -> unit ->
  object

    method is_bool : bool

  end
