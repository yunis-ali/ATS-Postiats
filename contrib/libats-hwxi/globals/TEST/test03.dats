(*
** HX-2013-06:
** Statically allocated list-stack
*)

(* ****** ****** *)

staload S = "./stack.dats"

(* ****** ****** *)

implement
main0 () =
{
//
val () = $S.push(0)
val () = $S.push(1)
val () = $S.push(2)
val () = println! ("$S.pop_exn() = ", $S.pop_exn())
val () = println! ("$S.pop_exn() = ", $S.pop_exn())
val () = $S.push(3)
val () = println! ("$S.pop_exn() = ", $S.pop_exn())
val () = println! ("$S.pop_exn() = ", $S.pop_exn())
//
val () = println! ("$S.isnil((*void*)) = ", $S.isnil())
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [test03.dats] *)
