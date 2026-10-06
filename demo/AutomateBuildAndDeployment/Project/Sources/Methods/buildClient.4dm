// ----------------------------------------------------
// Method: buildClient
// Description
// 	This method builds the client side for the client/server application.
//
// Parameters
// ----------------------------------------------------
#DECLARE()->$result : Object

var $build : cs:C1710.Build4D.Client
var $settings; $archive : Object
var $success : Boolean

$settings:={}

$settings.startElevated:=True:C214

// Define the project file
$settings.projectFile:=Folder:C1567(fk desktop folder:K87:19).file("demo-Build4D-Win/Project/demo-Build4D-Win.4DProject")

// Define the 4D Volume Desktop path
$settings.sourceAppFolder:=Folder:C1567(fk documents folder:K87:21).folder("4D 20 R8 100333/4D Volume Desktop")

// Configure the application
$settings.buildName:="clientApp"
$settings.publishName:="myAppCli"
$settings.destinationFolder:=Folder:C1567(fk desktop folder:K87:19).folder("buildApp/Client")

//add ipAddress
$settings.IPAddress:="127.0.0.1"

// Add the application information
$settings.versioning:={}
$settings.versioning.version:="1.0.0"
$settings.versioning.copyright:="copyright"
$settings.versioning.companyName:="4D SAS"

// Create the client application
$build:=cs:C1710.Build4D.Client.new($settings)
$success:=$build.build()

// Create the client application archive
$archive:=$build.buildArchive()

If ($success & $archive.archive.exists)
	$result:=New object:C1471("success"; $success; "logs"; $build.logs; "archiveClientWinPath"; $archive.archive.platformPath)
Else 
	$result:=New object:C1471("success"; $success; "logs"; $build.logs)
End if 