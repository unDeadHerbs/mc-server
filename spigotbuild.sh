wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
java -jar BuildTools.jar
rm -rf Bukkit CraftBukkit Spigot BuildData apache-maven*

