structure Main =
struct
  open Util

  fun makeMain main () =
    let val args = CommandLine.arguments () in
      OS.Process.exit (main args)
    end

  fun exit status =
    if OS.Process.isSuccess status
    then status
    else
      (println "vbs-util: A tool for avoiding writing VimL.";
       println "";
       println "Usage:";
       println "  vbs-util invert <file>.du";
       println "  vbs-util unused <file>.du";
       println "  vbs-util config <file>.json <key>[.<key>...]";
       status)

  fun main' argv =
    case argv
      of "invert"::rest => exit (InvertDefUse.invert rest)
       | "unused"::rest => exit (UnusedDefs.unused rest)
       | "config"::rest => exit (Config.get rest)
       | _ => exit OS.Process.failure

  fun main () = makeMain main' ()
end
