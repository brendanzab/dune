(** DSL to define sets that are defined by a membership : 'a -> bool function. *)

open! Stdune
open Dune_sexp

type 'a t =
  | Element of 'a
  | Compl of 'a t
  | Standard
  | Union of 'a t list
  | Inter of 'a t list

val diff : 'a t -> 'a t -> 'a t

val inter : 'a t list -> 'a t

val compl : 'a t -> 'a t

val union : 'a t list -> 'a t

val not_union : 'a t list -> 'a t

val any : 'a t

val decode_one : 'a Decoder.t -> 'a t Decoder.t

val decode : 'a Decoder.t -> 'a t Decoder.t

val encode : 'a Encoder.t -> 'a t Encoder.t

val to_dyn : 'a Dyn.builder -> 'a t Dyn.builder

val test : 'a t -> standard:'a t -> test:('a -> 'b -> bool) -> 'b -> bool

val empty : 'a t

val compare : ('a -> 'a -> Ordering.t) -> 'a t -> 'a t -> Ordering.t

module Glob : sig
  module Element : sig
    type t =
      | Glob of Dune_glob.V1.t
      | Literal of string
  end

  type nonrec t = Element.t t

  val to_dyn : t -> Dyn.t

  val test : t -> standard:t -> string -> bool

  val of_glob : Dune_glob.V1.t -> t

  (** [of_string_list xs] return an expression that will match any element
      inside the list [xs] *)
  val of_string_list : string list -> t

  (** [of_string_list xs] return an expression that will only match any element
      inside the set [xs] *)
  val of_string_set : String.Set.t -> t

  val compare : t -> t -> Ordering.t

  val hash : t -> int

  val decode : t Dune_sexp.Decoder.t

  val encode : t -> Dune_sexp.t
end