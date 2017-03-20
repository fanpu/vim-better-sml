(*
 * Process information from 'mlton -show-def-use <file>' to be more suitable for
 * type queries (i.e., given cursor position in file, respond with a type).
 *
 * 'def-use' files look like this:
 *
 * def1
 *     use1
 *     use2
 *     use3
 * def2
 *     use4
 *     use5
 * def3
 * def4
 *     use6
 *
 * So, it's easy to look up all uses given a definition.
 * For type queries, we want to look up the single definition, given a location
 * (which may be either a use or a def).
 * Thus, we want to 'invert' the def-use file, to get a use-def file.
 *
 * def1
 * def1
 *     use1
 * def1
 *     use2
 * def1
 *     use3
 * def1
 * def2
 * def2
 *     use4
 * def2
 *     use5
 * def2
 * def3
 * def3
 * def4
 * def4
 *     use6
 * def4
 *
 * Lines come in pairs: a location (i.e., use OR def) followed by a def
 * This means that each def is printed n + 2 times if that def has n uses.
 *
 * Requirements:
 *   MLton <http://mlton.org>
 *
 * Usage:
 *   # Build this file to an executable with MLton (only once)
 *   mlton invert-def-use.sml
 *
 *   # Create the def-use file [optional: stop after type checking]
 *   mlton [-stop tc] -show-def-use def-use.txt (foo.mlb|foo.sml) ...
 *
 *   # Invert the def-use.txt file
 *   invert-def-use def-use.txt > use-def.txt
 *)

fun println str = print (str ^ "\n")

fun makeMain main () =
  let val args = CommandLine.arguments () in
    OS.Process.exit (main args)
  end

val isUse = String.isPrefix "    "

fun eval
  (init : unit -> 'a)
  (trystep : 'a -> 'a option)
  : 'a =
  let
    fun unfold state =
      case trystep state
        of NONE => state
         | SOME state' => unfold state'
  in
    unfold (init ())
  end

fun main [defUseFilename] =
  let
    val file = TextIO.openIn defUseFilename

    fun init () =
      let
        val maybeFirstDef = TextIO.inputLine file
        val maybeFirstLine = TextIO.inputLine file
      in
        (case maybeFirstDef
           of SOME firstDef => (print firstDef; print firstDef)
            | _ => ());
        (maybeFirstDef, maybeFirstLine)
      end

    fun step (_, NONE) = NONE
      | step (NONE, _) = raise Fail "Impossible"
      | step (SOME curDef, SOME line) =
        if isUse line
        then
          (print line;
           print curDef;
           SOME (SOME curDef, TextIO.inputLine file))
        else
          (print line;
           print line;
           SOME (SOME line, TextIO.inputLine file))
  in
    eval init step;
    TextIO.closeIn file;
    OS.Process.success
  end
| main _ =
  (println "usage: invert-def-use <def-use-filename>";
   OS.Process.failure)


val _ = makeMain main ()
