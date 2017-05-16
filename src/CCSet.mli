
(* This file is free software, part of containers. See file "license" for more details. *)

(** {1 Wrapper around Set}

    @since 0.9 *)

type 'a sequence = ('a -> unit) -> unit
type 'a printer = Format.formatter -> 'a -> unit

module type S = sig
  include Set.S

  val of_seq : elt sequence -> t

  val add_seq : t -> elt sequence -> t
  (** @since 0.14 *)

  val to_seq : t -> elt sequence

  val of_list : elt list -> t
  (** Build a set from the given list of elements,
      added in order using {!add}. *)

  val add_list : t -> elt list -> t
  (** @since 0.14 *)

  val to_list : t -> elt list

  val pp :
    ?start:string -> ?stop:string -> ?sep:string ->
    elt printer -> t printer
end

module Make(O : Set.OrderedType) : S
  with type t = Set.Make(O).t
   and type elt = O.t
