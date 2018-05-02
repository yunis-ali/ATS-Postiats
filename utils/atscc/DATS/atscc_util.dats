(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2013 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
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
(* Start time: July, 2013 *)
(* Authoremail: hwxiATcsDOTbuDOTedu *)

(* ****** ****** *)
//
staload
STDLIB =
"libats/libc/SATS/stdlib.sats"
//
(* ****** ****** *)
//
#define ATSOPT_DEFAULT "patsopt"
//
(* ****** ****** *)
//
staload "./../SATS/atscc.sats"
//
macdef
unsome(opt) = stropt_unsome(,(opt))
macdef
issome(opt) = stropt_is_some(,(opt))
//
(* ****** ****** *)

implement
{}(*tmp*)
atsopt_get() = let
//
val def =
  $STDLIB.getenv_gc ("PATSOPT")
//
in
//
if
strptr2ptr(def) > 0
then strptr2string(def)
else let
//
prval() =
 strptr_free_null(def) in ATSOPT_DEFAULT
//
end (* end of [if] *)
// end of [if]
//
end // end of [atsopt_get]

(* ****** ****** *)

#define ATSOPT_USAGE "\
Usage: patscc [options] ...
//
Options:
//
-h:
This flag is a short form of [--help].
//
--help:
This flag is for inquiring usage information on atscc.
//
-hats:
This flag is for inquiring usage information on atsopt.
//
-vats:
This flag is for inquiring version information on atsopt.
//
-ccats:
This flag indicates that atscc is only required to compile files
containing ATS code into corresponding files containing C code and
it should not attempt to compile the generated C code.
//
-tcats:
This flag indicates that atscc is only required to typecheck files
containing ATS code.
//
--gline:
This flag is passed to atsopt for generating line pragma information
in the generated C code.
//
-verbose:
This flag indicates that each command-line executed by atscc should
be printed out.
//
-cleanaft:
This flag indicates that each C file generated by atsopt should be
removed once subsequent C-compilation is finished.
//
-atsccomp:
This flag indicates that the next argument is to be interpreted as
the C-compilation command subsequently employed for processing the
generated C files. If this flag is not present, then the value of the
environment variable ATSCCOMP is interpreted as the C-compilation command.
//
-DATS:
//
This flag indicates that the next argument, which should be a name
or name/value pair (separated by the symbol =), is to be passed to
atsopt as a top-level definition.
//
-DDATS:
//
This flag indicates that the next argument, which should be a
name or name/value pair (separated by the symbol =), is to be passed
to both atsopt and the subsequent C-compilation command as a top-level
definition.
//
-IATS:
This flag indicates that the next argument should be passed to
atsopt as an include-path.
//
-IIATS:
This flag indicates that the next argument should be passed to both
atsopt and the subsequent C-compilation command as an include-path.
//
-fsats:
This flag indicates that the next argument should be interpreted as
the name of a file containing static ATS code. Note that this flag is
unnecessary if the name of the file ends with the extension .sats.
//
-fdats:
This flag indicates that the next argument should be interpreted as
the name of a file containing dynamic ATS code. Note that this flag is
unnecessary if the name of the file ends with the extension .dats.
//
--tlcalopt-disable:
This flag is passed to patsopt to disable tail-call optimization,
which is needed for atscc-compilers such as atscc2erl and atscc2scm.
//
(*
//
// HX:
// no support yet:
//
--constraint-export:
This flag indicates that the constaints generated during typechecking
are to be exported so as to allows them be to solved externally.
*)
//
--constraint-ignore:
This flag indicates that constaint-solving is to be ignored during
typechecking. Note that this is a dangerous flag and it is only suggested
to be used with proper justification (such as constraint-solving being
performed externally)
//
" (* end of [ATSOPT_USAGE] *)
//
implement
{}(*tmp*)
atsopt_print_usage() =
fprint_string (stdout_ref, ATSOPT_USAGE)
//
(* ****** ****** *)
//
(*
#define
ATSCCOMP_DEFAULT "\
gcc -std=c99 -D_XOPEN_SOURCE \
-I${PATSHOME} -I${PATSHOME}/ccomp/runtime \
-L${PATSHOME}/ccomp/atslib/lib -L${PATSHOME}/ccomp/atslib/lib64 \
"
*)
#define
ATSCCOMP_DEFAULT "\
gcc -std=c99 -D_XOPEN_SOURCE \
-I${PATSHOME} -I${PATSHOME}/ccomp/runtime -L${PATSHOME}/ccomp/atslib/lib  \
"
//
(* ****** ****** *)

(*
(*
** HX: this one is suggested by Barry Schwartz, MN, USA
*)
#define
ATSCCOMP_DEFAULT2 "\
gcc -std=c99 \
-D_XOPEN_SOURCE \
-I${PATSHOME} -I${PATSHOME}/ccomp/runtime \
-L${PATSHOME}/ccomp/atslib/lib -L${PATSHOME}/ccomp/atslib/lib64 \
-Wl,--warn-common \
"
*)

(* ****** ****** *)

implement
{}(*tmp*)
atsccomp_get () = let
//
val def =
  $STDLIB.getenv_gc ("PATSCCOMP")
//
in
//
if
strptr2ptr (def) > 0
then strptr2string (def)
else let
  prval () = strptr_free_null(def) in ATSCCOMP_DEFAULT
end // end of [else]
//
end // end of [atsccomp_get]
  
(* ****** ****** *)

implement
{}(*tmp*)
atsccomp_get2
  (cas) = let
(*
val () =
println! ("atsccomp_get2")
*)
in
//
case+ cas of
//
| list_cons
    (ca, cas) =>
  (
  case+ ca of
  | CAatsccomp
      (opt) => (
      if issome(opt)
        then unsome(opt)
        else atsccomp_get2(cas)
      // end of [if]
    ) (* end of [CAatsccomp] *)
  | _ (*void*) => atsccomp_get2(cas)
  ) (* end of [list_cons] *)
//
| list_nil() => atsccomp_get()
//
end // end of [atsccomp_get2]

(* ****** ****** *)

(* end of [atscc_util.dats] *)
