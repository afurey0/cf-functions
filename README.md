# cf-functions

## queryToStruct
Takes a query result set object and returns a struct representation of the data. Supports the three query serialization layouts used by ColdFusion's serializeJSON method: (1) normal, (2) by column, and (3) as an array of structs. By default, the function also uses the query's meta data to attach corresponding meta data to the generated arrays and structs. This allows the ColdFusion deserializeJSON function to maintain consistent types for data fields.

[Read more about how meta data is used for serialization in ColdFusion.](https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-functions/functions-s/serializejson.html\#structserialization)

### Usage
`queryToStruct(myQuery, byColumn, setMetaData)`

| Argument | Type | Flags | Description |
| --- | --- | --- | --- |
| myQuery | query | Required | A query result set (as returned by `<cfquery>`, `queryExecute()`, etc) to convert into a struct |
| byColumn | boolean&#124;string | Optional | If `true`, use the column-style format. If `false`, use the normal format. If `"struct"`, format as an array of structs. Default: `false`. |
| setMetaData | boolean | Optional | If `true`, sets the meta data for the generated structs and arrays using the query's meta data. Default: `true`. |

### Caveats
The following caveats only apply if setMetaData is `true`:
- To avoid a type error when serializing, blank cells in numeric columns will be replaced by `null` instead of `""`.
- Passing in a query that does not have typed columns (such as one created by `queryNew()` without the `columnTypeList` argument) results in undefined behavior.
- This function uses an internal data structure to map query column types (varchar, integer, datetime, etc) to ColdFusion types (string, numeric, date, etc). If your database uses types that are not included in that structure, you must add them yourself by modifying the type map struct near the top of the function code.

Other caveats:
- This function does not validate your data.

### Example
```coldfusion
<cfscript>
qData = queryNew("name,superSecretCode", "varchar,varchar", [["John D", "2E7D"], ["Susie Q", "0232"]]);
badStruct = deserializeJSON(serializeJSON(qData, "struct"));
goodStruct = queryToStruct(qData, "struct");
//do stuff with the data...
badSerialized = serializeJSON(badStruct);
goodSerialized = serializeJSON(goodStruct);
</cfscript>
```
In the above example, notice that to build `badStruct` we have to turn our query into a JSON string and then convert that into a ColdFusion struct - not exactly efficient. Even worse, `badSerialized` will serialize `"0232"` as `232`, losing the leading "0" and changing the data type from string to integer.

When `goodStruct` is serialized, the built-in `serializeJSON` function will read the meta data attached by the `queryToStruct` function. This meta data says column 2 is of type varchar, so `"0232"` will be serialized as `"0232"`.

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
