(* ****** ****** *)
(*
** For writing ATS code
** that translates into R(stat)
*)
(* ****** ****** *)
//
// HX-2017-10:
// prefix for external names
//
#define
ATS_EXTERN_PREFIX "ats2r34pre_ML_"
//
(* ****** ****** *)
//
//
#define
LIBATSCC_targetloc
"$PATSHOME/contrib/libatscc"
//
#staload "./../../basics_r34.sats"
//
#include "{$LIBATSCC}/SATS/ML/list0.sats"
//
(* ****** ****** *)
//
fun{a:t0p}
fprint_list0
  (R34filr, list0(INV(a))): void = "mac#%"
//
fun{}
fprint_list0$sep(out: R34filr): void = "mac#%"
//
fun{a:t0p}
fprint_list0_sep
  (R34filr, list0(INV(a)), sep: string): void = "mac#%"
//
overload fprint with fprint_list0 of 100
//
(* ****** ****** *)
//
fun
list0_head_exn
  {a:t0p}
  (list0(INV(a))): (a) = "mac#%"
fun
list0_tail_exn
  {a:t0p}
  (list0(INV(a))): list0(a) = "mac#%"
//
overload .head with list0_head_exn
overload .tail with list0_tail_exn
//
(* ****** ****** *)
//
fun
list0_get_at_exn
  {a:t0p}
  (list0(INV(a)), intGte(0)): (a) = "mac#%"
//
(* ****** ****** *)
//
fun
list0_insert_at_exn
  {a:t0p}
(
  xs: list0(INV(a)), i: intGte(0), x0: a
) : list0(a) = "mac#%" // end-of-function
//
(* ****** ****** *)
//
fun
list0_remove_at_exn
  {a:t0p}
  (xs: list0(INV(a)), i: intGte(0)): list0(a) = "mac#%"
//
(* ****** ****** *)

(* end of [list0.sats] *)
