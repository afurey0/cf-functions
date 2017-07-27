# cf-functions

## recursiveMap
Similar to arrayMap and structMap, except that it recurses into the given struct or array. Can handle structs or arrays that contain combinations of structs, arrays, and simple values. Anything that is not a struct, array, or simple value is not touched by the map function and will be left intact.

### Usage
`myMappedStructOrArray = recursiveMap(myStructOrArray, myMapCallback);`

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
