// ----------------------------------------------------
// Method: buildServer
// Description
// 	This method builds the server side for the client/server application.
//
// Parameters
// ----------------------------------------------------
#DECLARE($archiveClientPath)->$result : Object
var $build : cs:C1710.Build4D.Server
var $settings : Object
var $success : Boolean

LOG EVENT:C667(Into system standard outputs:K38:9; "🖥️ Running inside buildServer...\r\n")
$settings:={}
$settings.startElevated:=True:C214

// Define the external project file
$settings.projectFile:=Folder:C1567(fk desktop folder:K87:19).file("demo-Build4D-Win/Project/demo-Build4D-Win.4DProject")

// Define the 4D Server path
$settings.sourceAppFolder:=Folder:C1567(fk documents folder:K87:21).folder("4D 20 R8 100333/4D Server")

// Configure the application
$settings.buildName:="serverApp"
$settings.publishName:="myAppServ"
$settings.destinationFolder:=Folder:C1567(fk desktop folder:K87:19).folder("buildApp/Server")

// Add the application icon
//$settings.iconPath:="/RESOURCES/myIcon.ico"

// Add the application information
$settings.versioning:={}
$settings.versioning.version:="1.0.0"
$settings.versioning.copyright:="copyright"
$settings.versioning.companyName:="4D SAS"

// Add the widows client archive
If ($archiveClientPath#Null:C1517 & File:C1566($archiveClientPath; fk platform path:K87:2).exists)
	$settings.windowsClientArchive:=$archiveClientPath
End if 

// Launch the build
$build:=cs:C1710.Build4D.Server.new($settings)

$success:=$build.build()
$result:=New object:C1471("success"; $success; "logs"; $build.logs)