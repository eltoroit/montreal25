String result = '';
for (Integer i = 1; i <= 100; i++) {
	result += i;
	if (i < 100) {
		result += '.';
	}
}
System.debug(result);
ETAI_Helpers.debugStringInChunks(result, 20);
