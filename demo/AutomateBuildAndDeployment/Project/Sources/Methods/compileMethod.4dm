// ----------------------------------------------------
// Method: compileMethod
// Description
// 	This method compiles the project using the path provided in the --user-param parameter.
//
// Parameters
// ----------------------------------------------------

LOG EVENT:C667(Into system standard outputs:K38:9; "Compilation starts\r\n")
var $projectPath : Text
var $result : Integer
var $compilationReturn : Object

// Getting the string value of the --user-param parameter in the CLI
$result:=Get database parameter:C643(User param value:K37:94; $projectPath)

If ($projectPath#"")
	$compilationReturn:=Compile project:C1760(File:C1566($projectPath))
	LOG EVENT:C667(Into system standard outputs:K38:9; "Compilation returns : \r\n"+JSON Stringify:C1217($compilationReturn; *))
End if 

