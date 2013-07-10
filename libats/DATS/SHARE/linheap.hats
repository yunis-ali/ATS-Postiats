(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2012 Hongwei Xi, ATS Trustful Software, Inc.
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
(* Start time: December, 2012 *)

(* ****** ****** *)

implement{a}
compare_elt_elt
  (x1, x2) = gcompare_ref<a> (x1, x2)
// end of [compare_elt_elt]

(* ****** ****** *)

implement{a}
linheap_getmin
  (hp0, res) = let
  val cp = linheap_getmin_ref (hp0)
in
//
if isneqz(cp) then let
  prval
  (
    pf, fpf | p
  ) = $UN.cptr_vtake{a}(cp)
  val () = res := !p
  prval () = fpf (pf)
  prval () = opt_some{a}(res) in true
end else let
  prval () = opt_none{a}(res) in false
end // end of [if]
//
end // end of [linheap_getmin]

(* ****** ****** *)
  
implement{a}
linheap_getmin_opt
  (hp0) = let
//
var res: a? // unintialized
val ans = linheap_getmin (hp0, res)
//
in
//
if ans then let
  prval () = opt_unsome{a}(res) in Some_vt{a}(res)
end else let
  prval () = opt_unnone{a}(res) in None_vt{a}((*void*))
end // end of [if]
//
end // end of [linheap_getmin_opt]

(* ****** ****** *)

implement{a}
linheap_delmin_opt
  (hp0) = let
//
var res: a? // unintialized
val ans = linheap_delmin (hp0, res)
//
in
//
if ans then let
  prval () = opt_unsome{a}(res) in Some_vt{a}(res)
end else let
  prval () = opt_unnone{a}(res) in None_vt{a}((*void*))
end // end of [if]
//
end // end of [linheap_delmin_opt]

(* ****** ****** *)

(* end of [linheap.hats] *)
