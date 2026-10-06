// ----------------------------------------------------
// Method: buildCompiledStructure
// Description
// 	This method builds a compiled structure for the project.
//
// Parameters
// ----------------------------------------------------

var $build : cs:C1710.Build4D.CompiledProject
var $settings : Object
var $success : Boolean

$settings:=New object:C1471()
$settings.destinationFolder:=Folder:C1567(fk desktop folder:K87:19).folder("builtStructure/")
$settings.buildName:="myCompiledStructure"

$settings.includePaths:=New collection:C1472
$settings.includePaths.push(New object:C1471("source"; "Resources/"))

$build:=cs:C1710.Build4D.CompiledProject.new($settings)
$success:=$build.build()