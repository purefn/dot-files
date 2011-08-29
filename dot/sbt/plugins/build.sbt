resolvers += {
  val typesafeRepoUrl = new java.net.URL("http://repo.typesafe.com/typesafe/releases")
  val pattern = Patterns(false, "[organisation]/[module]/[sbtversion]/[revision]/[type]s/[module](-[classifier])-[revision].[ext]")
  Resolver.url("Typesafe Repository", typesafeRepoUrl)(pattern)
}

libraryDependencies <<= (libraryDependencies, sbtVersion) { (deps, version) => 
  val sbtEclipseVersion = Map("0.10" -> "1.1").get(version).getOrElse("1.3-RC3")
  deps :+ ("com.typesafe.sbteclipse" %% "sbteclipse" % sbtEclipseVersion extra("sbtversion" -> version))
}

resolvers += "less is" at "http://repo.lessis.me"

libraryDependencies <+= sbtVersion(v => "me.lessis" %% "sbt-growl-plugin" % "0.1.2-%s".format(v))
