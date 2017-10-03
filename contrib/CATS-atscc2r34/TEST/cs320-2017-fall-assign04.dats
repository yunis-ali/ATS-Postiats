(* ****** ****** *)
//
// HX-2017-10:
// A running example
// from ATS2 to R(stat)
//
(* ****** ****** *)
//
#define
ATS_DYNLOADFLAG 0
//
(* ****** ****** *)
//
#define
LIBATSCC2R34_targetloc
"$PATSHOME/contrib/libatscc2r34"
//
(* ****** ****** *)
//
#include "{$LIBATSCC2R34}/mylibies.hats"
//
(* ****** ****** *)

abstype
R34vector(a:t@ype)

extern
fun
{a:t@ype}
R34vector_mean(R34vector(double)): double

overload mean with R34vector_mean

implement
R34vector_mean(xs) = #extfcall(double, "mean", xs)

(* ****** ****** *)

mean(mydata)

abstype R34dframe

(* ****** ****** *)



(* ****** ****** *)

#define
NDX100 "NDX100"

%{$
NDX100_get <-
function() { read.csv(NDX100, header=TRUE) }
%} // end of [%{$]

(* ****** ****** *)