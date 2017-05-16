
(* This file is free software, part of containers. See file "license" for more details. *)

(** {1 Array Slice} *)

type 'a sequence = ('a -> unit) -> unit
type 'a klist = unit -> [`Nil | `Cons of 'a * 'a klist]
type 'a gen = unit -> 'a option
type 'a equal = 'a -> 'a -> bool
type 'a ord = 'a -> 'a -> int
type 'a random_gen = Random.State.t -> 'a
type 'a printer = Format.formatter -> 'a -> unit

type 'a t
(** Array slice, containing elements of type ['a] *)

val empty : 'a t

val equal : 'a equal -> 'a t equal

val compare : 'a ord -> 'a t ord

val get : 'a t -> int -> 'a

val get_safe : 'a t -> int -> 'a option
(** [get_safe a i] returns [Some a.(i)] if [i] is a valid index
    @since 0.18 *)

val make : 'a array -> int -> len:int -> 'a t
(** Create a slice from given offset and length..
    @raise Invalid_argument if the slice isn't valid *)

val of_slice : ('a array * int * int) -> 'a t
(** Make a sub-array from a triple [(arr, i, len)] where [arr] is the array,
    [i] the offset in [arr], and [len] the number of elements of the slice.
    @raise Invalid_argument if the slice isn't valid (See {!make}) *)

val to_slice : 'a t -> ('a array * int * int)
(** Convert into a triple [(arr, i, len)] where [len] is the length of
    the subarray of [arr] starting at offset [i] *)

val to_list : 'a t -> 'a list
(** Convert directly to a list
    @since 1.0 *)

val full : 'a array -> 'a t
(** Slice that covers the full array *)

val underlying : 'a t -> 'a array
(** Underlying array (shared). Modifying this array will modify the slice *)

val copy : 'a t -> 'a array
(** Copy into a new array *)

val sub : 'a t -> int -> int -> 'a t
(** Sub-slice *)

val set : 'a t -> int -> 'a -> unit

val length : _ t -> int

val fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a

val foldi : ('a -> int -> 'b -> 'a) -> 'a -> 'b t -> 'a
(** Fold left on array, with index *)

val fold_while : ('a -> 'b -> 'a * [`Stop | `Continue]) -> 'a -> 'b t -> 'a
(** Fold left on array until a stop condition via [('a, `Stop)] is
    indicated by the accumulator
    @since 0.8 *)

val iter : ('a -> unit) -> 'a t -> unit

val iteri : (int -> 'a -> unit) -> 'a t -> unit

val blit : 'a t -> int -> 'a t -> int -> int -> unit
(** [blit from i into j len] copies [len] elements from the first array
    to the second. See {!Array.blit}. *)

val reverse_in_place : 'a t -> unit
(** Reverse the array in place *)

val sorted : ('a -> 'a -> int) -> 'a t -> 'a array
(** [sorted cmp a] makes a copy of [a] and sorts it with [cmp].
    @since 1.0 *)

val sort_indices : ('a -> 'a -> int) -> 'a t -> int array
(** [sort_indices cmp a] returns a new array [b], with the same length as [a],
    such that [b.(i)] is the index of the [i]-th element of [a] in [sort cmp a].
    In other words, [map (fun i -> a.(i)) (sort_indices a) = sorted cmp a].
    [a] is not modified.
    @since 1.0 *)

val sort_ranking : ('a -> 'a -> int) -> 'a t -> int array
(** [sort_ranking cmp a] returns a new array [b], with the same length as [a],
    such that [b.(i)] is the position in [sorted cmp a] of the [i]-th
    element of [a].
    [a] is not modified.

    In other words, [map (fun i -> (sorted cmp a).(i)) (sort_ranking cmp a) = a].

    Without duplicates, we also have
    [lookup_exn a.(i) (sorted a) = (sorted_ranking a).(i)]
    @since 1.0 *)

val find : ('a -> 'b option) -> 'a t -> 'b option
(** [find f a] returns [Some y] if there is an element [x] such
    that [f x = Some y], else it returns [None] *)

val findi : (int -> 'a -> 'b option) -> 'a t -> 'b option
(** Like {!find}, but also pass the index to the predicate function.
    @since 0.3.4 *)

val find_idx : ('a -> bool) -> 'a t -> (int * 'a) option
(** [find_idx p x] returns [Some (i,x)] where [x] is the [i]-th element of [l],
    and [p x] holds. Otherwise returns [None]
    @since 0.3.4 *)

val lookup : ?cmp:'a ord -> 'a -> 'a t -> int option
(** Lookup the index of some value in a sorted array.
    @return [None] if the key is not present, or
      [Some i] ([i] the index of the key) otherwise *)

val lookup_exn : ?cmp:'a ord -> 'a -> 'a t -> int
(** Same as {!lookup_exn}, but
    @raise Not_found if the key is not present *)

val bsearch : ?cmp:('a -> 'a -> int) -> 'a -> 'a t ->
  [ `All_lower | `All_bigger | `Just_after of int | `Empty | `At of int ]
(** [bsearch ?cmp x arr] finds the index of the object [x] in the array [arr],
    provided [arr] is {b sorted} using [cmp]. If the array is not sorted,
    the result is not specified (may raise Invalid_argument).

    Complexity: O(log n) where n is the length of the array
    (dichotomic search).

    @return
    - [`At i] if [cmp arr.(i) x = 0] (for some i)
    - [`All_lower] if all elements of [arr] are lower than [x]
    - [`All_bigger] if all elements of [arr] are bigger than [x]
    - [`Just_after i] if [arr.(i) < x < arr.(i+1)]
    - [`Empty] if the array is empty

    @raise Invalid_argument if the array is found to be unsorted w.r.t [cmp]
    @since 0.13 *)

val for_all : ('a -> bool) -> 'a t -> bool

val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
(** Forall on pairs of arrays.
    @raise Invalid_argument if they have distinct lengths
    allow different types @since 0.20 *)

val exists : ('a -> bool) -> 'a t -> bool

val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
(** Exists on pairs of arrays.
    @raise Invalid_argument if they have distinct lengths
    allow different types @since 0.20 *)

val fold2 : ('acc -> 'a -> 'b -> 'acc) -> 'acc -> 'a t -> 'b t -> 'acc
(** Fold on two arrays stepwise.
    @raise Invalid_argument if they have distinct lengths
    @since 0.20 *)

val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
(** Iterate on two arrays stepwise.
    @raise Invalid_argument if they have distinct lengths
    @since 0.20 *)

val shuffle : 'a t -> unit
(** Shuffle randomly the array, in place *)

val shuffle_with : Random.State.t -> 'a t -> unit
(** Like shuffle but using a specialized random state *)

val random_choose : 'a t -> 'a random_gen
(** Choose an element randomly.
    @raise Not_found if the array/slice is empty *)

val to_seq : 'a t -> 'a sequence
val to_gen : 'a t -> 'a gen
val to_klist : 'a t -> 'a klist

(** {2 IO} *)

val pp: ?sep:string -> 'a printer -> 'a t printer
(** Print an array of items with printing function *)

val pp_i: ?sep:string -> (int -> 'a printer) -> 'a t printer
(** Print an array, giving the printing function both index and item *)
