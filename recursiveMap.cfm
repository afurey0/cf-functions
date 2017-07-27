<cfscript>
	function recursiveMap(object, callback) {
		function _recursiveMap(value, index, full) {
			if (isSimpleValue(value)) {
				return callback(value, index, full);
			} else if (isStruct(value)) {
				return structMap(value, function(key, val, stru) {
					return _recursiveMap(val, key, stru);
				});
			} else if (isArray(value)) {
				return arrayMap(value, function(val, ind, arr) {
					return _recursiveMap(val, ind, arr);
				});
			} else {
				return v;
			}
		}
		return _recursiveMap(object);
	}
</cfscript>
