import java.io.{ByteArrayOutputStream, PrintWriter}
import sbt.{ProcessBuilder, ProcessLogger}

net.virtualvoid.sbt.graph.Plugin.graphSettings

javaOptions += "-agentpath:/home/rwallace/Development/yjp/bin/linux-x86-64/libyjpagent.so"

// def runCommand(cmd: Seq[String]): (Int, String, String) = {
//   val stdout = new ByteArrayOutputStream
//   val stderr = new ByteArrayOutputStream
//   val stdoutWriter = new PrintWriter(stdout)
//   val stderrWriter = new PrintWriter(stderr)

//   val exitValue = cmd.!(new ProcessLogger {
//     def info (s: => String) { stdoutWriter.print(s) }
//     def error (s: => String) { stderrWriter.print(s) }
//     def buffer[T] (f: => T): T = f
//   })

//   stdoutWriter.close()
//   stderrWriter.close()
//   (exitValue, stdout.toString, stderr.toString)
// }

// def gitBranch = {
//   runCommand("git rev-parse --abbrev-ref HEAD".split(" ").toSeq) match {
//     case (exit, _, _)  if(exit != 0)  => "No-Git"
//     case (_, stdout, _)               => stdout
//   }
// }

// shellPrompt := { state =>
//   //Special Characters
//   val branch = "\uE0A0"
//   val lock   = "\uE0A2"
//   val rArrow = "\uE0B0"
//   val lArrow = "\uE0B2"

//   def textColor(color: Int)      = { s"\033[38;5;${color}m" }
//   def backgroundColor(color:Int) = { s"\033[48;5;${color}m" }
//   def reset                      = { s"\033[0m" }

//   def formatText(str: String)(txtColor: Int, backColor: Int) = {
//     s"${textColor(txtColor)}${backgroundColor(backColor)}${str}${reset}"
//   }

//   val reset_fg = 0
//   val a_fg = 232
//   val a_bg = 192
//   val a_sep_fg = 192
//   val b_fg = 192
//   val b_bg = 238

//   formatText(s" ${name.value} ")(a_fg, a_bg) +
//   formatText(rArrow)(a_sep_fg, b_bg) +
//   formatText(s" $branch $gitBranch ")(b_fg, b_bg) +
//   formatText(rArrow)(b_bg, reset_fg) +
//   " "
// }

