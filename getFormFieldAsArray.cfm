<cfscript>
	array function getFormFieldAsArray(required string fieldName) {
		return createObject("java", "java.util.Vector").init(createObject("java", "java.util.Arrays").asList(getPageContext().getRequest().getParameterValues(arguments.fieldName)));
	}
</cfscript>
