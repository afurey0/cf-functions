function queryToStruct(required query query, any byColumns=false, boolean setMetaData=true) {
		if (arguments.setMetaData) {
			local.typeMap = { "CHAR": "string", "VARCHAR": "string", "BINARY": "string", "VARBINARY": "string", "BLOB": "string", "TEXT": "string", "ENUM": "string", "SET": "string", "INT": "numeric", "INTEGER": "numeric", "": "numeric", "SMALLINT": "numeric", "TINYINT": "numeric", "MEDIUMINT": "numeric", "BIGINT": "numeric", "DECIMAL": "numeric", "NUMERIC": "numeric", "FLOAT": "numeric", "DOUBLE": "numeric", "BIT": "numeric", "YEAR": "numeric", "TIMESTAMP": "date", "DATETIME": "date", "DATE": "date", "TIME": "date", "": "string" };
		}
		if (isBoolean(arguments.byColumns)) {
			local.data = {};
			local.data.columns = [];
			if (arguments.byColumns) {
				local.data.data = {};
				if (arguments.setMetaData) {
					local.metaData = {};
					for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
						local.columnType = query.getMetaData().getColumnTypeName(c);
						if (structKeyExists(local.typeMap, local.columnType)) {
							local.columnName = arguments.query.getMetaData().getColumnName(c);
							local.metaData[local.columnName] = {
								name: local.columnName,
								items: local.typeMap[local.columnType]
							};
						}
					}
					local.data.data.setMetaData(local.metaData);
				}
			} else {
				local.data.data = [];
				if (arguments.setMetaData) {
					local.rowMetaData = {
						items: []
					};
					for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
						local.columnType = query.getMetaData().getColumnTypeName(c);
						if (structKeyExists(local.typeMap, local.columnType)) {
							arrayAppend(local.rowMetaData.items, local.typeMap[local.columnType]);
						} else {
							arrayAppend(local.rowMetaData.items, "string");
						}
					}
				}
			}
			for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
				local.columnName = arguments.query.getMetaData().getColumnName(c);
				arrayAppend(local.data.columns, local.columnName);
				if (arguments.byColumns) {
					local.data.data[local.columnName] = [];
				}
			}
			if (arguments.byColumns) {
				local.data.rowCount = query.recordCount;
				for (local.row in arguments.query) {
					for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
						local.value = local.row[local.data.columns[c]];
						arrayAppend(local.data.data[local.data.columns[c]], arguments.setMetaData and local.metaData[local.data.columns[c]].items neq "string" and local.value eq "" ? JavaCast("null", "") : local.value);
					}
				}
			} else {
				for (local.row in arguments.query) {
					local.rowData = [];
					if (arguments.setMetaData) {
						local.rowData.setMetaData(local.rowMetaData);
					}
					for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
						local.value = local.row[local.data.columns[c]];
						arrayAppend(local.rowData, arguments.setMetaData and local.rowMetaData.items[c] neq "string" and local.value eq "" ? JavaCast("null", "") : local.value);
					}
					arrayAppend(local.data.data, local.rowData);
				}
			}
		} else if (arguments.byColumns eq "struct") {
			if (arguments.setMetaData) {
				local.rowMetaData = {};
				for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
					local.columnType = query.getMetaData().getColumnTypeName(c);
					if (structKeyExists(local.typeMap, local.columnType)) {
						local.columnName = arguments.query.getMetaData().getColumnName(c);
						local.rowMetaData[local.columnName] = {
							name: local.columnName,
							type: local.typeMap[local.columnType]
						};
					}
				}
			}
			local.data = [];
			for (local.row in arguments.query) {
				local.rowData = {};
				if (arguments.setMetaData) {
					local.rowData.setMetaData(local.rowMetaData);
				}
				for (local.c = 1; local.c lte arguments.query.columnList.listLen(); local.c++) {
					local.columnName = arguments.query.getMetaData().getColumnName(c);
					local.value = local.row[local.columnName];
					local.rowData[local.columnName] = arguments.setMetaData and local.rowMetaData[local.columnName].type neq "string" and local.value eq "" ? JavaCast("null", "") : local.value;
				}
				arrayAppend(local.data, local.rowData);
			}
		}
		return local.data;
	}
