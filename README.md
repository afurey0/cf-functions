# cf-functions

## queryToStruct
Takes a query result set object and returns a struct representation of the data. Supports the three query serialization layouts used by ColdFusion's serializeJSON method: (1) normal, (2) by column, and (3) as an array of structs. By default, the function also uses the query's meta data to attach corresponding meta data to the generated arrays and structs. This allows the ColdFusion deserializeJSON function to maintain consistent types for data fields.

[Read more about serialization meta data in ColdFusion](https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-functions/functions-s/serializejson.html\#structserialization.)

### Usage
`queryToStruct(myQuery, byColumn, setMetaData)`

| Argument | Type | Flags | Description |
| --- | --- | --- | --- |
| myQuery | query | Required | The query object to convert into a struct |
| byColumn | boolean\|string | Optional | If true, use the column-style format. If false, use the normal format. If "struct", format as an array of structs. Default: false. |
| setMetaData | boolean | Optional | Whether or not to set the meta data for the generated structs an arrays using the query's meta data. Default: true. |

### Example
```coldfusion
<cfquery name="qData">...</cfquery>
<cfset badStruct = deserializeJSON(serializeJSON(qData, "struct")) />
<cfset goodStruct = queryToStruct(qData, "struct") />
<!--- do stuff with the data... --->
<cfset badSerialized = serializeJSON(badStruct) />
<cfset goodSerialized = serializeJSON(goodStruct) />
```
In the above example, `badSerialized` may have varying datatypes in the same column (e.g. `"002C73"` -> `"002C73"` but `"717074"` -> `717074`)! Plus you have to turn the whole query into a string before turning it into a struct. But for `goodSerialized`, meta data is attached to the generated struct so that it will serialize correctly.

## recursiveMap
Similar to arrayMap and structMap, except that it recurses into the given struct or array. Can handle structs or arrays that contain combinations of structs, arrays, and simple values. Anything that is not a struct, array, or simple value is not touched by the map function and will be left intact.

### Usage
`myMappedStructOrArray = recursiveMap(myStructOrArray, function(currentValue, keyOrIndex, fullObject) { ... });`

### Example
```coldfusion
<cfscript>

	// this complicated struct contains sub-structs and arrays!
	myComplicatedStruct = {
		"foo": "bar",
		"bin": [ "baz", "far", "fin" ],
		"faz": {
			"boo": "oof",
			"rab": [ "nib", "zab", "raf" ]
		}
	};
	
	// using recursiveMap, we replace every value in the struct with its first letter
	myComplicatedStruct = recursiveMap(myComplicatedStruct, function(value, index, full) {
		return left(value, 1);
	});
	
</cfscript>
```
End result for `myComplicatedStruct` is `{"f":"b","b":["b","f","f"],"f":{"b":"o","r":["n","z","r"]}}`
