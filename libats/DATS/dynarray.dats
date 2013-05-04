(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
** later version.
**
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
**
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)

(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: May, 2013 *)

(* ****** ****** *)

staload
UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "libats/SATS/dynarray.sats"

(* ****** ****** *)
//
// HX:
// recapacitizing policy
// 0: manual
// 1: automatic doubling
//
(* ****** ****** *)

implement{}
dynarray$recapacitize () = 1 // default policy

(* ****** ****** *)

local

datavtype
dynarray (a:vt@ype+) =
  {m,n:int | m > 0; m >= n}
  DYNARRAY of (arrayptr (a, m), size_t m, size_t n)
// end of [dynarray]

assume
dynarray_vtype (a) = dynarray (a)

in (* in of [local] *)

implement{a}
dynarray_make_nil
  (cap) = let
//
val A = arrayptr_make_uninitized<a> (cap)
val A = __cast (A) where
{
  extern castfn __cast {n:int} (arrayptr (a?, n)):<> arrayptr (a, n)
} (* end of [val] *)
//
in
  DYNARRAY (A, cap, g1i2u(0))
end (* end of [dynarray_make_nil] *)

(* ****** ****** *)

implement{}
dynarray_getfree_arrayptr
  (DA, n) = let
//
val+~DYNARRAY{a}{m,n}(A, _, n0) = DA
//
val () = n := n0
//
in
  $UN.castvwtp0{arrayptr(a,n)}(A)
end (* end of [dynarray_getfree_arrayptr] *)

(* ****** ****** *)

implement{}
dynarray_get_size (DA) = let
  val+DYNARRAY (_, _, n) = DA in (n)
end // end of [dynarray_get_size]
implement{}
dynarray_get_capacity (DA) = let
  val+DYNARRAY (_, m, _) = DA in (m)
end // end of [dynarray_get_capacity]

(* ****** ****** *)

implement{a}
dynarray_getref_at
  (DA, i) = let
//
val i = g1ofg0_uint (i)
val+DYNARRAY (A, m, n) = DA
val pi =
(
  if i < n then ptr_add<a> (arrayptr2ptr(A), i) else the_null_ptr
) : ptr // end of [val]
//
in
  $UN.cast{cPtr0(a)}(pi)
end // end of [dynarray_getref_at]

(* ****** ****** *)

(*
fun{a:vt0p}
dynarray_insert_at_opt
  (DA: !dynarray (INV(a)), i: size_t, x: a): Option_vt (a)
*)
implement{a}
dynarray_insert_at_opt
  (DA, i, x) = let
//
val+@DYNARRAY (A, m, n) = DA
//
val m1 = m
//
in
//
if i <= n then let
  extern fun memmove
    : (ptr, ptr, size_t) -<0,!wrt> ptr = "mac#atslib_memmove"
  // end of [extern]
in
//
if m > n then let
  val p1 =
    ptr_add<a> (arrayptr2ptr(A), i)
  val p2 = ptr_succ<a> (p1)
  val ptr =
    memmove (p2, p1, (n-i)*sizeof<a>)
  val () = $UN.ptr0_set<a> (p1, x)
  val () = n := succ(n)
  prval () = fold@ (DA)
in
  None_vt{a}( )
end else let
  prval () = fold@ (DA)
  val recap = dynarray$recapacitize ()
in
  if recap > 0 then let
    val _(*true*) = dynarray_reset_capacity<a> (DA, m1+m1)
  in
    dynarray_insert_at_opt (DA, i, x)
  end else let
    // no support for auto recapacitizing
  in
    Some_vt{a}(x)
  end // end of [if]
end // end of [if]
//
end else let
  prval () = fold@ (DA)
in
  Some_vt{a}(x)
end // end of [if]
//
end // end of [dynarray_insert_at_opt]

(* ****** ****** *)

implement{a}
dynarray_insert_atbeg_exn
  (DA, x) = let
//
val-~None_vt () =
  dynarray_insert_at_opt (DA, i2sz(0), x)
//
in
  // nothing
end // end of [dynarray_insert_atbeg_exn]
implement{a}
dynarray_insert_atbeg_opt
  (DA, x) = let
in
  dynarray_insert_at_opt (DA, i2sz(0), x)
end // end of [dynarray_insert_atbeg_opt]

(* ****** ****** *)

implement{a}
dynarray_insert_atend_exn
  (DA, x) = let
//
val+DYNARRAY (_, _, n) = DA
val-~None_vt () =
  dynarray_insert_at_opt (DA, n, x)
//
in
  // nothing
end // end of [dynarray_insert_atend_exn]
implement{a}
dynarray_insert_atend_opt
  (DA, x) = let
//
val+DYNARRAY (_, _, n) = DA
//
in
  dynarray_insert_at_opt (DA, n, x)
end // end of [dynarray_insert_atend_opt]

(* ****** ****** *)

implement{a}
dynarray_takeout_at_opt
  (DA, i) = let
//
val+@DYNARRAY (A, m, n) = DA
//
val i = g1ofg0_uint (i)
//
in
//
if i < n then let
  extern fun memmove
    : (ptr, ptr, size_t) -<0,!wrt> ptr = "mac#atslib_memmove"
  // end of [extern]
  val p1 = ptr_add<a> (arrayptr2ptr(A), i)
  val p2 = ptr_succ<a> (p1)
  val n1 = pred (n)
  val x = $UN.ptr0_get<a> (p1)
  val ptr = memmove (p1, p2, (n1-i)*sizeof<a>)
  val () = n := n1
  prval () = fold@ (DA)
in
  Some_vt{a}(x)
end else let
  prval () = fold@ (DA) in None_vt{a}( )
end // end of [if]
//
end // end of [dynarray_takeout_at_opt]

(* ****** ****** *)

implement{a}
dynarray_takeout_atbeg_opt
  (DA) = let
in
  dynarray_takeout_at_opt (DA, i2sz(0))
end // end of [dynarray_takeout_atbeg_opt]

implement{a}
dynarray_takeout_atend_opt
  (DA) = let
  val+DYNARRAY (_, _, n) = DA
in
  if n > 0 then dynarray_takeout_at_opt (DA, pred(n)) else None_vt{a}()
end // end of [dynarray_takeout_atend_opt]

(* ****** ****** *)

implement{a}
dynarray_reset_capacity
  (DA, m2) = let
//
val+@DYNARRAY (A, m, n) = DA
//
in
//
if m2 >= n then let
//
val A2 = arrayptr_make_uninitized<a> (m2)
val ptr = memcpy
(
  arrayptr2ptr(A2), arrayptr2ptr(A), n*sizeof<a>
) where {
  extern fun memcpy
    : (ptr, ptr, size_t) -<0,!wrt> ptr = "mac#atslib_memcpy"
} (* end of [val] *)
//
extern castfn __cast {n:int} (arrayptr (a, n)):<> arrayptr (a?, n)
extern castfn __cast2 {n:int} (arrayptr (a?, n)):<> arrayptr (a, n)
//
val A1 = __cast(A)
val A2 = __cast2(A2)
//
val () = arrayptr_free (A1)
//
val () = A := A2
val () = m := m2
prval () = fold@ (DA)
//
in
  true
end else let
//
prval () = fold@ (DA)
//
in
  false
end // end of [if]
//
end // end of [dynarray_reset_capacity]

(* ****** ****** *)

end // end of [local]

(* ****** ****** *)

implement{}
dynarray_free (DA) = let
  var n: size_t
  val A = dynarray_getfree_arrayptr (DA, n)
in
  arrayptr_free (A)
end (* end of [dynarray_free] *)

(* ****** ****** *)

implement{a}
dynarray_get_at_exn
  (DA, i) = let
//
val pi = dynarray_getref_at (DA, i)
//
in
//
if cptr2ptr(pi) > 0 then $UN.cptr_get (pi) else $raise ArraySubscriptExn()
//
end // end of [dynarray_get_at_exn]

implement{a}
dynarray_set_at_exn
  (DA, i, x) = let
//
val pi = dynarray_getref_at (DA, i)
//
in
//
if cptr2ptr(pi) > 0 then $UN.cptr_set (pi, x) else $raise ArraySubscriptExn()
//
end // end of [dynarray_set_at_exn]

(* ****** ****** *)

(* end of [dynarray.dats] *)
